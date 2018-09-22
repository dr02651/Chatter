//
//  EditProfileViewController.swift
//  Chatter
//
//  Created by Devodriq Roberts on 9/22/18.
//  Copyright © 2018 Devodriq Roberts. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var profileImage: RoundedImage!
    @IBOutlet weak var editProfileBG: UIView!
    
     @IBAction func prepareForUnwind(segue: UIStoryboardSegue){}
    
    // Variables
    private(set) var avatarBgColor = ""
    private(set) var avatarName = UserDataService.instance.avatarName
    private(set) var bgColor: UIColor?
    private(set) var avatarColor = UserDataService.instance.avatarColor
    
    weak var delegate: IconPresentable?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.image = UIImage(named: UserDataService.instance.avatarName)
        profileImage.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
    }
    
    
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    

    @IBAction func chooseAvatarPressed(_ sender: Any) {
        delegate?.goToIcons()
    }
    
    @IBAction func generateBgColorPressed(_ sender: UIButton) {
        let r = CGFloat(arc4random_uniform(255)) / 255
        let g = CGFloat(arc4random_uniform(255)) / 255
        let b = CGFloat(arc4random_uniform(255)) / 255
        bgColor = UIColor(red: r, green: g, blue: b, alpha: 0.75)
        avatarColor = "[\(r), \(g), \(b), 1]"
        UIView.animate(withDuration: 0.2) {
            self.profileImage.backgroundColor = self.bgColor
            UserDataService.instance.setAvatarColor(avatarColor: self.avatarColor)
        }
    }
    
    @IBAction func updateProfilePressed(_ sender: RoundedButton) {
    }
    
    
    
    
}
