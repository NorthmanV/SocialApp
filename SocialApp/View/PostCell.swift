//
//  PostCell.swift
//  SocialApp
//
//  Created by Руслан Акберов on 09.12.2017.
//  Copyright © 2017 Ruslan Akberov. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var likeImage: UIImageView!
    
    var post: Post!
    var likeRef: DatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        likeImage.addGestureRecognizer(tap)
        likeImage.isUserInteractionEnabled = true
        
    }
    
    func configureCell(post: Post, image: UIImage? = nil) {
        self.post = post
        self.caption.text = post.caption
        likeRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)
        self.likeLabel.text = "\(post.likes)"
        if image != nil {
            self.postImage.image = image
        } else {
            let ref = Storage.storage().reference(forURL: post.imageURL)
            ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("Unable to download image from Firebase storage")
                } else {
                    print("Image downloaded from Firebase storage")
                    if let imageData = data {
                        if let image = UIImage(data: imageData) {
                            self.postImage.image = image
                            FeedVC.imageCache.setObject(image, forKey: post.imageURL as NSString)
                        }
                    }
                }
            })
        }
        likeRef.observeSingleEvent(of: .value) { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImage.image = UIImage(named: "empty-heart")
            } else {
                self.likeImage.image = UIImage(named: "filled-heart")
            }
        }
    }
    
    @objc func likeTapped(sender: UITapGestureRecognizer) {
        likeRef.observeSingleEvent(of: .value) { snapshot in
            if let _ = snapshot.value as? NSNull {
                self.likeImage.image = UIImage(named: "filled-heart")
                self.post.adjustLikes(addLike: true)
                self.likeRef.setValue(true)
            } else {
                self.likeImage.image = UIImage(named: "empty-heart")
                self.post.adjustLikes(addLike: false)
                self.likeRef.removeValue()
            }
        }

    }
    
    
    
    
    
    


}
