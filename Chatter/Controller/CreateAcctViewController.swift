//
//  CreateAcctViewController.swift
//  Chatter
//
//  Created by Devodriq Roberts on 9/20/18.
//  Copyright © 2018 Devodriq Roberts. All rights reserved.
//

import UIKit
import SVProgressHUD

class CreateAcctViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var createAcctButton: RoundedButton!
    
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){}
    
    // Variables
    var avatarName = "profileDefault"
    var avatarColor = "[0.5, 0.5, 0.5, 1]"
    var bgColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        createAcctButton.isEnabled = true
        
        if UserDataService.instance.avatarName != "" {
            userImage.image = UIImage(named: UserDataService.instance.avatarName)
            avatarName = UserDataService.instance.avatarName
        }
        
        if avatarName.contains("light") && bgColor == nil {
            userImage.backgroundColor = UIColor.lightGray
        }
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    func unwindToHome() {
        performSegue(withIdentifier: UNWIND, sender: nil)
    }

    @IBAction func closeButtonPressed(_ sender: UIButton) {
        unwindToHome()
    }
    
    
    @IBAction func chooseAvatarPressed(_ sender: UIButton) {
        performSegue(withIdentifier: SHOW_ICONS, sender: self)
    }
    
    // MARK: Generate avatar background colors
    @IBAction func generateBgcolorPressed(_ sender: UIButton) {
        let r = CGFloat(arc4random_uniform(255)) / 255
        let g = CGFloat(arc4random_uniform(255)) / 255
        let b = CGFloat(arc4random_uniform(255)) / 255
        bgColor = UIColor(red: r, green: g, blue: b, alpha: 0.75)
        avatarColor = "[\(r), \(g), \(b), 1]"
        UIView.animate(withDuration: 0.2) {
            self.userImage.backgroundColor = self.bgColor
        }
    }
    
    
    // MARK: Set up placeholder attributes and Gesture recogn
    func setUpView() {
        usernameText.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSAttributedStringKey.foregroundColor : CHATTER_PLACEHOLDER_COLOR])
        emailText.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedStringKey.foregroundColor : CHATTER_PLACEHOLDER_COLOR])
        passwordText.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedStringKey.foregroundColor : CHATTER_PLACEHOLDER_COLOR])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
    }
    
    
    // Mark: Create Accout Button Pressed
    @IBAction func createAcctPressed(_ sender: UIButton) {
        createAcctButton.isEnabled = false
        SVProgressHUD.show()
        
        guard let name = usernameText.text, usernameText.text != " " else {return}
        guard let email = emailText.text, emailText.text != " " else {return}
        guard let password = passwordText.text, passwordText.text != " " else {return}
        
        // Auth service register user method
        AuthService.instance.registerUser(email: email, password: password) { (success) in
            if success {
                AuthService.instance.loginUser(email: email, password: password, completion: { (success) in
                    if success {
                        SVProgressHUD.dismiss()
                        AuthService.instance.createUser(name: name, email: email, avatarName: self.avatarName, avatarColor: self.avatarColor, completion: { (success) in
                            if success {
                                self.unwindToHome()
                                NotificationCenter.default.post(name: NOTIF_USER_DATA_CHANGED, object: nil)
                            }
                        })
                    }
                })
            }
        }
    }
    
    
    
}














