//
//  FancyView.swift
//  SocialApp
//
//  Created by Руслан Акберов on 02.12.2017.
//  Copyright © 2017 Ruslan Akberov. All rights reserved.
//

import UIKit

class FancyView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 3.0
        //layer.shadowOffset = CGSize(width: 1.0, height: 2.0)
        layer.shadowOffset = CGSize.zero
        layer.cornerRadius = 1.0
    }
}
