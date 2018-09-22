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
    
}
