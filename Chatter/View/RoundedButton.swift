//
//  RoundedButton.swift
//  Chatter
//
//  Created by Devodriq Roberts on 9/21/18.
//  Copyright © 2018 Devodriq Roberts. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 3.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    override func awakeFromNib() {
        self.applyFeatures()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        self.applyFeatures()
    }
    
    func applyFeatures() {
        self.layer.cornerRadius = cornerRadius
    }

}
