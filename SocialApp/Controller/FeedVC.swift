//
//  FeedVC.swift
//  SocialApp
//
//  Created by Руслан Акберов on 05.12.2017.
//  Copyright © 2017 Ruslan Akberov. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageAdd: UIImageView!
    @IBOutlet weak var captionField: FancyTextField!
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var imageSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        DataService.ds.REF_POSTS.observe(.value) { snapshot in
            self.posts = []
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    print("Snap: \(String(describing: snap.value))")
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let post = Post(postKey: snap.key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
           self.tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            if let image = FeedVC.imageCache.object(forKey: post.imageURL as NSString) {
                cell.configureCell(post: post, image: image)
                return cell
            } else {
                cell.configureCell(post: post)
                return cell
            }
        } else {
            return PostCell()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageAdd.image = image
            imageSelected = true
        } else {
            print("Valid image was't selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func adImageTapped(_ sender: UITapGestureRecognizer) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func postButtonTapped(_ sender: UIButton) {
        guard let _ = captionField.text, captionField.text != "" else {
            print("Caption must be entered")
            return
        }
        guard let image = imageAdd.image, imageSelected == true else {
            print("An image must be selected")
            return
        }
        if let imageData = UIImageJPEGRepresentation(image, 0.5) {
            let imageUid = NSUUID().uuidString
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            DataService.ds.REF_POST_IMAGES.child(imageUid).putData(imageData, metadata: metadata, completion: { (metadata, error) in
                if error != nil {
                    print("Unable to upload image to Firebase")
                } else {
                    print("Successfully uploaded image to Firebase Storage")
                    let downloadUrl = metadata?.downloadURL()?.absoluteString
                    if let url = downloadUrl {
                        self.postToFirebase(imageUrl: url)
                    }
                }
            })
        }
    }
    
    func postToFirebase(imageUrl: String) {
        let post: [String : Any] = [
            "caption": captionField.text!,
            "imageURL": imageUrl,
            "likes": 0
            ]
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        captionField.text = ""
        imageSelected = false
        imageAdd.image = UIImage(named: "add-image")
        tableView.reloadData()
    }
    
    @IBAction func signOutTapped(_ sender: UITapGestureRecognizer) {
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("ID removed from keychain \(keychainResult)")
        try! Auth.auth().signOut()
        self.dismiss(animated: true, completion: nil)
    }
    

}









