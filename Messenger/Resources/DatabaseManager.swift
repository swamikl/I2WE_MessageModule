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


// to get the name of the users that registered through email 
extension DatabaseManager {

    public func getDataFor(path: String, completion: @escaping (Result<Any, Error>) -> Void) {
        self.database.child("\(path)").observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            completion(.success(value))
        }
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
    
    // MARK: - Need to fix, if log in twice with FB the user gets added twice to the database 
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
    public func createNewConversation(with otherUserEmail: String, name: String, firstMessage: Message, completion: @escaping (Bool) -> Void) {
        
        guard let currentEmail = UserDefaults.standard.value(forKey: "email") as? String,
        let currentName = UserDefaults.standard.value(forKey: "name") as? String else {
            return
        }
        
        let safeEmail = DatabaseManager.safeEmail(emailAddress: currentEmail)
        
        // reference to the current user's node
        let ref = database.child("\(safeEmail)")
        
        ref.observeSingleEvent(of: .value, with: { [weak self] snapshot in
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
                "name": name,
                "latest_message": [
                    "date": dateString,
                    "message": message,
                    "is_read": false
                ]
            ]
            
            let recipient_newConversationData: [String: Any] = [
                           "id": conversationID,
                           "other_user_email": safeEmail,
                           "name": currentName,
                           "latest_message": [
                               "date": dateString,
                               "message": message,
                               "is_read": false
                           ]
                       ]
            
            
            // update recipient conversation entry
            self?.database.child("\(otherUserEmail)/conversations").observeSingleEvent(of: .value, with: { [weak self] snapshot in
                if var conversatoins = snapshot.value as? [[String: Any]] {
                    // append the message to the conversation
                    conversatoins.append(recipient_newConversationData)
                    self?.database.child("\(otherUserEmail)/conversations").setValue(conversationID)
                }
                else {
                    // create a new convo if there was not a convo already
                    self?.database.child("\(otherUserEmail)/conversations").setValue([recipient_newConversationData])
                }
            })
            
            
            
            // to update the conversation data for the current user
            if var conversations = userNode["conversations"] as? [[String: Any]]{
                // convo already exists for the user, just append to the convo
                
                conversations.append(newConversationData)
                userNode["conversations"] = conversations
                ref.setValue(userNode, withCompletionBlock: { [weak self] error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    self?.finishingSetupForConversations(name: name,
                                                         conversationID: conversationID, firstMessage: firstMessage, completion: completion)
                    
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
                    self?.finishingSetupForConversations(name: name,
                                                         conversationID: conversationID, firstMessage: firstMessage, completion: completion)
                    
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
    
    private func finishingSetupForConversations(name: String, conversationID: String, firstMessage: Message, completion: @escaping (Bool) -> Void){
        
        
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
            "is_read": false,
            "name": name
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
    public func getAllConversations(for email: String, completion: @escaping (Result<[Conversation], Error>) -> Void) {
        database.child("\(email)/conversations").observe(.value, with: { snapshot in
            guard let value = snapshot.value as? [[String: Any]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            
            // we are trying to pull the data from firebase. The structure of how the data is stored is outlined above
            // pretty confusing, followed tutorial
            let conversations: [Conversation] = value.compactMap({ dictionary in
                guard let conversationId = dictionary["id"] as? String,
                    let name = dictionary["name"] as? String,
                    let otherUserEmail = dictionary["other_user_email"] as? String,
                    let latestMessage = dictionary["latest_message"] as? [String: Any],
                    let date = latestMessage["date"] as? String,
                    let message = latestMessage["message"] as? String,
                    let isRead = latestMessage["is_read"] as? Bool else {
                        return nil
                }
                
                // Fro, the data we grabbed above, we are now making a message object
                let latestMmessageObject = LatestMessage(date: date,
                                                         text: message,
                                                         isRead: isRead)
                return Conversation(id: conversationId,
                                    name: name,
                                    otherUserEmail: otherUserEmail,
                                    latestMessage: latestMmessageObject)
            })
            completion(.success(conversations))
        })
    }
    
    /// getting all of the messages within a conversation
    public func getAllMessagesForConversation(with id: String, completion: @escaping (Result<[Message], Error>) -> Void) {
        database.child("\(id)/messages").observe(.value, with: { snapshot in
            guard let value = snapshot.value as? [[String: Any]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            
            let messages: [Message] = value.compactMap({ dictionary in
                            guard let name = dictionary["name"] as? String,
                                // prbably will not impliment read or not read options
                                let isRead = dictionary["is_read"] as? Bool,
                                let messageID = dictionary["id"] as? String,
                                let content = dictionary["content"] as? String,
                                let senderEmail = dictionary["sender_email"] as? String,
                                // right now we are only sending string messages, not photo or video 
                                let type = dictionary["type"] as? String,
                                let dateString = dictionary["date"] as? String,
                                let date = ChatViewController.dateFormatter.date(from: dateString)else {
                                return nil
                            }

                            let sender = Sender(photoURL: "",
                                                senderId: senderEmail,
                                                displayName: name)

                            return Message(sender: sender,
                                           messageId: messageID,
                                           sentDate: date,
                                           // needs to change if we do do photo or video messages 
                                           kind: .text(content))
                        })

                        completion(.success(messages))
                    })
                }
    
    /// sending message to a person in an exsisting convo
    // READ THIS PLEASE
    // this looks terrible right now and needs cleaning up, but the functionality is there, there is just alot of redundent code
    public func sendMessage(to conversation: String, otherUserEmail: String, name: String, newMessage: Message, completion: @escaping (Bool) -> Void) {
        // add new message to messages

        guard let myEmail = UserDefaults.standard.value(forKey: "email") as? String else {
            completion(false)
            return
        }
        
        let currentEmail = DatabaseManager.safeEmail(emailAddress: myEmail)
        
        database.child("\(conversation)/messages").observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard let strongSelf = self else {
                return
            }
            guard var currentMessages = snapshot.value as? [[String: Any]] else {
                completion(false)
                return
            }
            
            let messageDate = newMessage.sentDate
            let dateString = ChatViewController.dateFormatter.string(from: messageDate)
            
            var message = ""
            
            switch newMessage.kind {
                
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
            
            let newMessageEntry: [String: Any] = [
                "id": newMessage.messageId,
                "type": newMessage.kind.messageKindString,
                "content": message,
                "date": dateString,
                "sender_email": currentUserEmail,
                "is_read": false,
                 "name": name
            ]
            
            currentMessages.append(newMessageEntry)
            strongSelf.database.child("\(conversation)/messages").setValue(currentMessages) {error, _ in
                guard error == nil else {
                    completion(false)
                    return
                }
                
                // updates for the latest message
                strongSelf.database.child("\(currentEmail)/conversations").observeSingleEvent(of: .value, with: { snapshot in
                    guard var currentUserConversations = snapshot.value as? [[String: Any]] else {
                        completion(false)
                        return
                    }
                    
                    // for the most recent value
                    let updatedValue: [String: Any] = [
                        "date": dateString,
                        "is_read": false,
                        "message": message,
                        
                    ]
                    
                    var targetConversation: [String: Any]?
                    
                    
                    
                    var position = 0
                    // finding the message to make it the latest message
                    for conversation_loop in currentUserConversations {
                        if let currentId = conversation_loop["id"] as? String, currentId == conversation {
                            targetConversation = conversation_loop
                            break
                        }
                        position += 1
                    }
                    targetConversation?["latest_message"] = updatedValue
                    
                    guard let finalConversation = targetConversation else {
                        completion(false)
                        return
                    }
                    currentUserConversations[position] = finalConversation
                    strongSelf.database.child("\(currentEmail)/conversations").setValue(currentUserConversations, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        
                        // Update the latest message for the recipient user
                        strongSelf.database.child("\(otherUserEmail)/conversations").observeSingleEvent(of: .value, with: { snapshot in
                            guard var otherUserConversations = snapshot.value as? [[String: Any]] else {
                                completion(false)
                                return
                            }
                            
                            // for the most recent value
                            let updatedValue: [String: Any] = [
                                "date": dateString,
                                "is_read": false,
                                "message": message,
                                
                            ]
                            
                            var targetConversation: [String: Any]?
                            
                            
                            
                            var position = 0
                            // finding the message to make it the latest message
                            for conversation_loop in otherUserConversations {
                                if let currentId = conversation_loop["id"] as? String, currentId == conversation {
                                    targetConversation = conversation_loop
                                    break
                                }
                                position += 1
                            }
                            targetConversation?["latest_message"] = updatedValue
                            
                            guard let finalConversation = targetConversation else {
                                completion(false)
                                return
                            }
                            otherUserConversations[position] = finalConversation
                            strongSelf.database.child("\(otherUserEmail)/conversations").setValue(otherUserConversations, withCompletionBlock: { error, _ in
                                guard error == nil else {
                                    completion(false)
                                    return
                                }
                                completion(true)
                            })
                        })
                        
                    })
                })
                
            }
            
        })
        
        // update sender latest message
        // update recipient latest message
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

