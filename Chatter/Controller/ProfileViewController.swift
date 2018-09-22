//
//  ProfileViewController.swift
//  Chatter
//
//  Created by Devodriq Roberts on 9/22/18.
//  Copyright © 2018 Devodriq Roberts. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var profileImage: RoundedImage!
    @IBOutlet weak var BgView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    
    func setUpView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleBgTap))
        view.addGestureRecognizer(tap)
        
        nameLabel.text = UserDataService.instance.name
        emailLabel.text = UserDataService.instance.email
        profileImage.image = UIImage(named: UserDataService.instance.avatarName)
        profileImage.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
    }
    
    @objc func handleBgTap() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        UserDataService.instance.logoutUser()
        NotificationCenter.default.post(name: NOTIF_USER_DATA_CHANGED, object: nil)
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
