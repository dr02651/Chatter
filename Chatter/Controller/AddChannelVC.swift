//
//  AddChannelVC.swift
//  Chatter
//
//  Created by Devodriq Roberts on 9/22/18.
//  Copyright © 2018 Devodriq Roberts. All rights reserved.
//

import UIKit

class AddChannelVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var descriptionText: UITextField!
    @IBOutlet weak var createChannelBg: UIView!
    @IBOutlet weak var createChannelButton: RoundedButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        createChannelButton.isEnabled = true
    }
    
    
    
    @objc func handleTap() {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // Add new channel
    @IBAction func createChannelButtonPressed(_ sender: RoundedButton) {
        createChannelButton.isEnabled = false
        guard let channelName = titleText.text, titleText.text != "" else {return}
        guard let channelDescription = descriptionText.text, descriptionText.text != "" else {return}
        
        SocketService.instance.addChannelWith(name: channelName, description: channelDescription) { (success) in
            if success {
                self.createChannelButton.isEnabled = true
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    func setUpView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        createChannelBg.addGestureRecognizer(tap)
        
        titleText.attributedPlaceholder = NSAttributedString(string: "title", attributes: [NSAttributedStringKey.foregroundColor : CHATTER_PLACEHOLDER_COLOR])
        
        descriptionText.attributedPlaceholder = NSAttributedString(string: "description", attributes: [NSAttributedStringKey.foregroundColor : CHATTER_PLACEHOLDER_COLOR])
    }
}











