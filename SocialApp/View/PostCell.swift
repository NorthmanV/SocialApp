//
//  PostCell.swift
//  SocialApp
//
//  Created by Руслан Акберов on 09.12.2017.
//  Copyright © 2017 Ruslan Akberov. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var lakeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(post: Post) {
        self.caption.text = post.caption
        self.lakeLabel.text = "\(post.likes)"
    }
    
    
    


}
