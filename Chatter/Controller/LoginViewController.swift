//
//  LoginViewController.swift
//  Chatter
//
//  Created by Devodriq Roberts on 9/20/18.
//  Copyright © 2018 Devodriq Roberts. All rights reserved.
//

import UIKit
import SVProgressHUD

class LoginViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var loginButton: RoundedButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        loginButton.isEnabled = true
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        view.endEditing(true)
        loginButton.isEnabled = false
        SVProgressHUD.show()
        
        guard let email = emailText.text, emailText.text != "" else {return}
        guard let password = passwordText.text, passwordText.text != "" else {return}
        
        AuthService.instance.loginUser(email: email, password: password) { (success) in
            if success {
                AuthService.instance.findUserByEmail(completion: { (success) in
                    if success {
                        NotificationCenter.default.post(name: NOTIF_USER_DATA_CHANGED, object: nil)
                        SVProgressHUD.dismiss()
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        self.loginButton.isEnabled = true
                    }
                })
            }
        }
    }
    
    @IBAction func noAcctButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: TO_CREATE_ACCT, sender: self)
    }
    
    // MARK: Set up placeholder attributes and Gesture recogn
    func setUpView() {
        emailText.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedStringKey.foregroundColor : CHATTER_PLACEHOLDER_COLOR])
        passwordText.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedStringKey.foregroundColor : CHATTER_PLACEHOLDER_COLOR])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
    }
    
    
}
