//
//  ChatViewController.swift
//  Chatter
//
//  Created by Devodriq Roberts on 9/20/18.
//  Copyright © 2018 Devodriq Roberts. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController  {
    
    // Outlets
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var channelNameLabel: UILabel!
    @IBOutlet weak var chatTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var typingUserLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: Add Targets ##############################################################################
        menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        chatTextField.addTarget(self, action: #selector(userStartTyping), for: .editingDidBegin)
        chatTextField.addTarget(self, action: #selector(userStopTyping), for: .editingDidEnd)
        chatTextField.addTarget(self, action: #selector(sendBtnEnabled), for: .editingChanged)
        
        
        //MARK: Add Gesture Recognizer ####################################################################
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        
        //MARK: Assign delegate and dataSource #############################################################
        tableView.delegate = self
        tableView.dataSource = self
        
        
        //MARK: Observe notification changes ###############################################################
        NotificationCenter.default.addObserver(self, selector: #selector(userDataChanged), name: NOTIF_USER_DATA_CHANGED, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(channelSelected), name: NOTIF_CHANNEL_SELECTED, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: NOTIF_USER_LOGOUT, object: nil)
        
        
        //MARK: Socket service get messages #################################################################
        SocketService.instance.getMessages { (success) in
            if success {
                self.tableView.reloadData()
                if MessageService.instance.messages.count > 0 {
                    let endIndex = IndexPath(row: MessageService.instance.messages.count - 1, section: 0)
                    self.tableView.scrollToRow(at: endIndex, at: .bottom, animated: false)
                }
            }
        }
        
        
        //MARK: Display typing users #################################################################
        SocketService.instance.gettypingUsers { (typingUsers) in
            guard let channelId = MessageService.instance.selectedChannel?.id else {return}
            var names = ""
            var numberOfUsersTyping = 0
            
            for (typingUser, channel) in typingUsers {
                if typingUser != UserDataService.instance.name && channel == channelId {
                    if names == "" {
                        names = typingUser
                    } else {
                        names = "\(names), \(typingUser)"
                    }
                    numberOfUsersTyping += 1
                }
            }
            
            if numberOfUsersTyping > 0 && AuthService.instance.isLoggedIn {
                var verb = "is"
                if numberOfUsersTyping > 1 {
                    verb = "are"
                }
                self.typingUserLabel.text = "\(names) \(verb) typing..."
            } else {
                self.typingUserLabel.text = ""
            }
        }
        
        
        //MARK: View utils ##############################################################################
        view.bindToKeyboard()
        addTapGR()
        sendButton.isEnabled = false
        
        
        //MARK: Notification post when logged in  #########################################################
        if AuthService.instance.isLoggedIn {
            AuthService.instance.findUserByEmail { (success) in
                NotificationCenter.default.post(name: NOTIF_USER_DATA_CHANGED, object: nil)
            }
        }
        
        
        MessageService.instance.findAllChannels { (success) in
            self.reloadTableView()
        }
    }
    
    
    //MARK: Changing send button visibility ################################################################
    @objc func userStopTyping() {
        if chatTextField.text == "" {
            sendButton.isHidden = true
        }
        guard let channelId = MessageService.instance.selectedChannel?.id else {return}
        SocketService.instance.socket.emit("stopType", UserDataService.instance.name, channelId)
    }
    
    
    @objc func userStartTyping() {
            sendButton.isHidden = false
        guard let channelId = MessageService.instance.selectedChannel?.id else {return}
        SocketService.instance.socket.emit("startType", UserDataService.instance.name, channelId)
    }
    
    
    @objc func sendBtnEnabled() {
        chatTextField.text != "" ? (sendButton.isEnabled = true) : (sendButton.isEnabled = false)
    }
    
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    
    //MARK: Tap Gesture R ##############################################################################
    func addTapGR(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
    }
    
    
    
    // MARK: Notification / User data changed / set channel button text and user image ######################
    @objc func userDataChanged(_ notification: Notification) {
        if AuthService.instance.isLoggedIn {
            // Get channels
            onLogInGetMessages()
            channelNameLabel.text = "Chatter"
        } else {
            channelNameLabel.text = "Please Log In"
            reloadTableView()
        }
    }
    
    
    @objc func channelSelected() {
        updateWithChannel()
    }
    
    
    @objc func reloadTableView() {
        tableView.reloadData()
    }
    
    
    // Updates chat vc label and chat text field placeholder ###############################################
    func updateWithChannel() {
        channelNameLabel.text  = MessageService.instance.selectedChannel?.channelTitle ?? "Chatter"
        let chatPlacholder = MessageService.instance.selectedChannel?.channelTitle ?? "Send Message"
        chatTextField.attributedPlaceholder = NSAttributedString(string: "#\(chatPlacholder)")
        getmessages()
    }
    
    
    // Find all app channels #############################################################################
    func onLogInGetMessages() {
        MessageService.instance.findAllChannels { (success) in
            if success {
                if MessageService.instance.channels.count > 0 {
                    MessageService.instance.setSelectedChannel(to: MessageService.instance.channels[0])
                    self.updateWithChannel()
                } else {
                    self.channelNameLabel.text = "No channels yet!"
                }
            }
        }
    }
    
    
    func getmessages() {
        guard let channelId = MessageService.instance.selectedChannel?.id else {return}
        MessageService.instance.findAllMessages(forChannelId: channelId) { (success) in
            if success {
                self.reloadTableView()
            }
        }
    }
    
    
    
    
    //MARK: Send button pressed ############################################################################
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        sendButton.isEnabled = false
        let user = UserDataService.instance
        if AuthService.instance.isLoggedIn {
            
            guard let channelId = MessageService.instance.selectedChannel?.id else {return}
            guard let message = chatTextField.text else {return}
            
            SocketService.instance.socket.emit("stopType", user.name, channelId)
            SocketService.instance.addMessagesWith(messageBody: message, userId: user.id, channelId: channelId) { (success) in
                self.chatTextField.text = ""
                self.chatTextField.resignFirstResponder()
                self.sendButton.isHidden = true
            }
        }
    }
}


// MARK: Table view delegate and datasource ################################################################
extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as? MessageCell else {return MessageCell()}
        cell.configureCellWith(message: MessageService.instance.messages[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.messages.count
    }
}
























