//
//  ChatViewController.swift
//  Chatter
//
//  Created by Devodriq Roberts on 9/20/18.
//  Copyright © 2018 Devodriq Roberts. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var channelNameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        NotificationCenter.default.addObserver(self, selector: #selector(userDataChanged), name: NOTIF_USER_DATA_CHANGED, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(channelSelected), name: NOTIF_CHANNEL_SELECTED, object: nil)
        
        
        if AuthService.instance.isLoggedIn {
            AuthService.instance.findUserByEmail { (success) in
                NotificationCenter.default.post(name: NOTIF_USER_DATA_CHANGED, object: nil)
            }
        }
        
        MessageService.instance.findAllChannels { (success) in
            //
        }
    }
    
    // MARK: Notification / User data changed / set channel button text and user image
    @objc func userDataChanged(_ notification: Notification) {
        if AuthService.instance.isLoggedIn {
            // Get channels
            onLogInGetMessages()
            channelNameLabel.text = "Chatter"
        } else {
            channelNameLabel.text = "Please Log In"
        }
    }
    
    @objc func channelSelected() {
        updateWithChannel()
    }
    
    func updateWithChannel() {
        channelNameLabel.text  = MessageService.instance.selectedChannel?.channelTitle ?? "Chatter"
        getmessages()
    }
    
    
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
            //
        }
    }
    
    
}
