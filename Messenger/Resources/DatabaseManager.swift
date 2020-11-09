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
    
    static func safeEmail(emailAddress: String) -> String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
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
    public func insertUser(with user: AppUser, completion: @escaping (Bool) -> Void) {
        database.child(user.safeEmail).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName
            ], withCompletionBlock: { error, _ in
                guard error == nil else {
                    print("failed ot write to database")
                    completion(false)
                    return
                }
                
                self.database.child("users").observeSingleEvent(of: .value, with: { snapshot in
                    if var usersCollection = snapshot.value as? [[String: String]] {
                        // append to user dictionary
                        let newElement = [
                            "name": user.firstName + " " + user.lastName,
                            "email": user.safeEmail
                        ]
                        usersCollection.append(newElement)
                        
                        self.database.child("users").setValue(usersCollection, withCompletionBlock: { error, _ in
                            guard error == nil else {
                                completion(false)
                                return
                            }
                            
                            completion(true)
                        })
                    }
                    else {
                        // create that array
                        let newCollection: [[String: String]] = [
                            [
                                "name": user.firstName + " " + user.lastName,
                                "email": user.safeEmail
                            ]
                        ]
                        
                        self.database.child("users").setValue(newCollection, withCompletionBlock: { error, _ in
                            guard error == nil else {
                                completion(false)
                                return
                            }
                            
                            completion(true)
                        })
                    }
                })
        })
    }
    
    public func getAllUsers(completion: @escaping (Result<[[String: String]], Error>) -> Void) {
        database.child("users").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [[String: String]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            
            completion(.success(value))
        })
    }
    
    public enum DatabaseError: Error {
        case failedToFetch
    }
    
}


// how the users are being stored in the database for eacch user
/*
 users => [
 [
 "name":
 "safe_email":
 ],
 [
 "name":
 "safe_email":
 ]
 ]
 */

// how we are storing the messages
/*
 "uniqueId" {
 // this is holding a collection of messages
 "messages": [
 {
 "id": String,
 "type": text
 "content": String,
 "date": Date(),
 "sender_email": String,
 "isRead": true/false,
 }
 ]
 }
 
 conversaiton => [
 [
 "conversation_id": "UniqueId"
 "other_user_email":
 "latest_message": => {
 "date": Date()
 "latest_message": "message"
 "is_read": true/false
 }
 ],
 ]
 */


// MARK: - Sending Messages/ Convo
extension DatabaseManager {
    
    /// creating new convo with target user
    public func createNewConversation(with otherUserEmail: String, firstMessage: Message, completion: @escaping (Bool) -> Void) {
        
        guard let currentEmail = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        
        let safeEmail = DatabaseManager.safeEmail(emailAddress: currentEmail)
        
        // reference to the current user's node
        let ref = database.child("\(safeEmail)")
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            guard var userNode = snapshot.value as? [String: Any] else {
                completion(false)
                print("cannot find the user")
                return
            }
            
            // getting the date for each message
            let messageDate = firstMessage.sentDate
            let dateString = ChatViewController.dateFormatter.string(from: messageDate)
            
            var message = ""
            
            switch firstMessage.kind {
                
            case .text(let messageText):
                message = messageText
            case .attributedText(_):
                break
            // will prob not impliment this on first release
            case .photo(_):
                break
            case .video(_):
                break
            case .location(_):
                break
            case .emoji(_):
                break
            case .audio(_):
                break
            case .contact(_):
                break
            case .linkPreview(_):
                break
            case .custom(_):
                break
            }
            
            let conversationID = "conversation_\(firstMessage.messageId)"
            
            let newConversationData: [String: Any] = [
                "id": conversationID,
                "other_user_email": otherUserEmail,
                "latest_message": [
                    "date": dateString,
                    "message": message,
                    "is_read": false
                ]
            ]
            
            
            
            if var conversations = userNode["conversations"] as? [[String: Any]]{
                // convo already exists for the user, just append to the convo
                
                conversations.append(newConversationData)
                userNode["conversations"] = conversations
                ref.setValue(userNode, withCompletionBlock: { [weak self] error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    self?.finishingSetupForConversations(conversationID: conversationID, firstMessage: firstMessage, completion: completion)
                    
                })
                
            }
            else{
                // gotta make a new convo since it does not exist in the database currently
                userNode["conversations"] = [newConversationData]
                
                ref.setValue(userNode, withCompletionBlock: { [weak self] error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    self?.finishingSetupForConversations(conversationID: conversationID, firstMessage: firstMessage, completion: completion)
                    
                })
                
            }
        })
    }
    
    // the structure of the convo node
    // {
    //            "id": String,
    //            "type": text, photo, video,
    //            "content": String,
    //            "date": Date(),
    //            "sender_email": String,
    //            "isRead": true/false,
    //        }
    
    private func finishingSetupForConversations(conversationID: String, firstMessage: Message, completion: @escaping (Bool) -> Void){
        
        
        // getting the date for each message
                   let messageDate = firstMessage.sentDate
                   let dateString = ChatViewController.dateFormatter.string(from: messageDate)
        
        var message = ""
        
        switch firstMessage.kind {
            
        case .text(let messageText):
            message = messageText
        case .attributedText(_):
            break
        // will prob not impliment this on first release
        case .photo(_):
            break
        case .video(_):
            break
        case .location(_):
            break
        case .emoji(_):
            break
        case .audio(_):
            break
        case .contact(_):
            break
        case .linkPreview(_):
            break
        case .custom(_):
            break
        }
        
        
        guard let myEmail = UserDefaults.standard.value(forKey: "email") as? String else {
            completion(false)
            return
        }
        
        let currentUserEmail = DatabaseManager.safeEmail(emailAddress: myEmail)
        
        let collectionOfMessages: [String: Any] = [
            "id": firstMessage.messageId,
            "type": firstMessage.kind.messageKindString,
            "content": message,
            "date": dateString,
            "sender_email": currentUserEmail,
            "is_read": false
        ]
        
        
        let value: [String: Any] = [
            "messages": [
                collectionOfMessages
            ]
        ]
        
        database.child("\(conversationID)").setValue(value, withCompletionBlock: { error, _ in
            guard error == nil else {
                completion(false)
                return
            }
            completion(true)
        })
    }
    
    /// getting all the convo for the user with the passed in email
    public func getAllConversations(for email: String, completion: @escaping (Result<String, Error>) -> Void) {
        
    }
    
    /// getting all of the messages within a conversation
    public func getAllMessagesForConversation(with id: String, completion: @escaping (Result<String, Error>) -> Void) {
        
    }
    
    /// sending message to a person in an exsisting convo
    public func sendMessage(to conversation: String, message: Message, completion: @escaping (Bool) -> Void) {
        
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
    var profilePictureFileName: String {
        // all the profile pictures are saved in the format shown below
        return "\(safeEmail)_profile_picture.png"
    }
}

