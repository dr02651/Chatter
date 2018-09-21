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
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customize the amount of the rear view controller that is shown on menu button tap (view width - 60pt)
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
    }

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: LOGIN_SEGUE, sender: self)
    }
    
    @IBOutlet weak var addChannelButtonPressed: UIButton!
    

}
