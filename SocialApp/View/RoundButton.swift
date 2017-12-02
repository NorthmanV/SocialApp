//
//  RoundButton.swift
//  SocialApp
//
//  Created by Руслан Акберов on 02.12.2017.
//  Copyright © 2017 Ruslan Akberov. All rights reserved.
//

import UIKit

@IBDesignable class RoundButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.7
        layer.shadowRadius = 1.0
        layer.shadowOffset = CGSize(width: 1.0, height: 3.0)
        
    }

    

}
