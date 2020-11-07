//
//  DatabaseManager.swift
//  Messenger
//
//  Created by Swamik Lamichhane on 10/21/20.
//  Copyright © 2020 Swamik Lamichhane. All rights reserved.
//

// this is going to be the file that will handle all of the database read and write
// this is so that we will not have redundent code in all of the controllers



import Foundation
import FirebaseDatabase

// we do not want this class to be subclassed
final class DatabaseManager {
    
    // we are makig this a singleton for easy read and write
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    
    
}

// MARK: - Functions to Manage the Accounts


extension DatabaseManager {
    
    // this is to make sure that people cannot register with the same email twice
    // the snapshot is getting the data from the data base
    // if database.child(email) is already in database thus we do not want to create the account
    public func userExistis(with email: String,
                            completion: @escaping ((Bool) -> Void)){
        
        
        // for database.child, the child does not allow special char like "." and "@"
        // so we need to do some sort of replacements to the email so that we can put it in the database
        // in the database the emails will have "-" insted of "."
        // in the database the emails will have "-" insted of "@"
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        

        database.child(safeEmail).observeSingleEvent(of: .value, with: {snapshot in
            guard snapshot.value as? String != nil else  {
                completion(false)
                return
            }
            completion(true)
        })
    }
    
    // this is what is writing to our data base
    // the email address is the key so no 2 users can have the same email
    // set value is what is writing this info to the firebase database
    /// inserts new user to database
    public func insertUser(with user: AppUser) {
        database.child(user.safeEmail).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName
        ])
    }
}


struct AppUser {
    
    let firstName: String
    let lastName: String
    let emailAddress: String
    
    var safeEmail: String {
        // making this inside so we can just use this property when we use this struct
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    // let profilePictureUrl: String
}

