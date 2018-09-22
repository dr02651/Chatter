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
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customize the amount of the rear view controller that is shown on menu button tap (view width - 60pt)
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
        
        NotificationCenter.default.addObserver(self, selector: #selector(userDataChanged), name: NOTIF_USER_DATA_CHANGED, object: nil)
    }
    
    // MARK: Notification / User data changed / set channel button text and user image
    @objc func userDataChanged(_ notification: Notification) {
        if AuthService.instance.isLoggedIn {
            loginButton.setTitle(UserDataService.instance.name, for: .normal)
            userImage.image = UIImage(named: UserDataService.instance.avatarName) //?? UIImage(named: "menuProfileIcon")
            userImage.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
        } else {
            loginButton.setTitle("login", for: .normal)
            userImage.image = UIImage(named: "menuProfileIcon")
            userImage.backgroundColor = UIColor.clear
            
        }
    }

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: LOGIN_SEGUE, sender: self)
    }
    
    @IBOutlet weak var addChannelButtonPressed: UIButton!

}
