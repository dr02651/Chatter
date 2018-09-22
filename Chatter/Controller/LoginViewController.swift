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
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }

    @IBAction func closeButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        SVProgressHUD.show()
    }
    
    @IBAction func noAcctButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: TO_CREATE_ACCT, sender: self)
    }
    
     // MARK: Set up placeholder attributes and Gesture recogn
    func setUpView() {
        usernameText.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSAttributedStringKey.foregroundColor : CHATTER_PLACEHOLDER_COLOR])
        passwordText.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedStringKey.foregroundColor : CHATTER_PLACEHOLDER_COLOR])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
    }
    
}
