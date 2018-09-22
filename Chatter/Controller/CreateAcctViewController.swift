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
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){}
    
    // Variables
    private(set) var avatarName = "profileDefault"
     private(set) var avatarColor = "[0.5, 0.5, 0.5, 1]"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
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
    
    @IBAction func generateBgcolorPressed(_ sender: UIButton) {
    }
    
    @IBAction func createAcctPressed(_ sender: UIButton) {
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
                            }
                        })
                    }
                })
            }
        }
    }
    
    
    
}














