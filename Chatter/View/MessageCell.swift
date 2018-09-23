//
//  MessageCell.swift
//  Chatter
//
//  Created by Devodriq Roberts on 9/23/18.
//  Copyright © 2018 Devodriq Roberts. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    @IBOutlet weak var avatarImage: RoundedImage!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var messageTimeStampLabel: UILabel!
    @IBOutlet weak var messageBodyLabel: UILabel!
    
    @IBOutlet weak var messageCellView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCellWith(message: Message) {
        avatarImage.image = UIImage(named: message.userAvatar)
        avatarImage.backgroundColor = UserDataService.instance.returnUIColor(components: message.userAvatarColor)
        userNameLabel.text = message.userName
        //messageTimeStampLabel.text = message.timeStamp
        messageBodyLabel.text = message.message
        
    }

}
