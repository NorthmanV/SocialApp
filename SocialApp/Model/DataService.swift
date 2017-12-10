//
//  DataService.swift
//  SocialApp
//
//  Created by Руслан Акберов on 10.12.2017.
//  Copyright © 2017 Ruslan Akberov. All rights reserved.
//

import Foundation
import Firebase

let FIREDB = Database.database().reference() //URL of DB

class DataService {
    
    static let ds = DataService()
    
    private var _REF_DB = FIREDB
    private var _REF_POSTS = FIREDB.child("posts")
    private var _REF_USERS = FIREDB.child("users")
    
    var REF_DB: DatabaseReference {
        return _REF_DB
    }
    
    var REF_POSTS: DatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    
}

















