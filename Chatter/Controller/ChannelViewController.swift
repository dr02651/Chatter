//
//  ChannelViewController.swift
//  Chatter
//
//  Created by Devodriq Roberts on 9/20/18.
//  Copyright © 2018 Devodriq Roberts. All rights reserved.
//

import UIKit

class ChannelViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var userImage: RoundedImage!
    @IBOutlet weak var channelTableView: UITableView!
    
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        channelTableView.delegate = self
        channelTableView.dataSource = self
        
        // Customize the amount of the rear view controller that is shown on menu button tap (view width - 60pt)
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
        
        NotificationCenter.default.addObserver(self, selector: #selector(userDataChanged), name: NOTIF_USER_DATA_CHANGED, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(channelsLoaded), name: NOTIF_CHANNELS_LOADED, object: nil)
        
        SocketService.instance.getChannel { (success) in
            if success {
                self.channelTableView.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setUpUserInfo()
    }
    
    // MARK: Notification / User data changed / set channel button text and user image
    @objc func userDataChanged(_ notification: Notification) {
        setUpUserInfo()
    }
    
    @objc func channelsLoaded(_ notification: Notification) {
        channelTableView.reloadData()
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        if AuthService.instance.isLoggedIn {
            let profile = ProfileViewController()
            profile.modalPresentationStyle = .custom
            present(profile, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: LOGIN_SEGUE, sender: self)
        }
        
    }
    
    
    func setUpUserInfo() {
        if AuthService.instance.isLoggedIn {
            loginButton.setTitle(UserDataService.instance.name, for: .normal)
            userImage.image = UIImage(named: UserDataService.instance.avatarName)
            userImage.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
        } else {
            loginButton.setTitle("login", for: .normal)
            userImage.image = UIImage(named: "menuProfileIcon")
            userImage.backgroundColor = UIColor.clear
            channelTableView.reloadData()
        }
    }
    
    @IBAction func addChannelButtonPressed(_ sender: UIButton) {
        
        if AuthService.instance.isLoggedIn {
            let addChannelVc = AddChannelVC()
            addChannelVc.modalPresentationStyle = .custom
            present(addChannelVc, animated: true, completion: nil)
        }
    }
    
    
}

extension ChannelViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "channelCell", for: indexPath) as? ChannelCell else {return ChannelCell()}
        cell.configureCell(channel: MessageService.instance.channels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = MessageService.instance.channels[indexPath.row]
        MessageService.instance.setSelectedChannel(to: channel)
        NotificationCenter.default.post(name: NOTIF_CHANNEL_SELECTED, object: nil)
        
        self.revealViewController().revealToggle(animated: true)
    }
    
}













