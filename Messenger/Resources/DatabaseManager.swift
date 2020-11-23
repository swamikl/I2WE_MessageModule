//
//  DatabaseManager.swift
//  Messenger
//
//  Created by Swamik Lamichhane on 10/21/20.
//  Copyright © 2020 Swamik Lamichhane. All rights reserved.
//

// this is going to be the file that will handle all of the database read and write
// this is so that we will not have redundent code in all of the controllers
// Referenced an IOS messenging app to learn how to use swift and building an IOS app.
// https://www.youtube.com/playlist?list=PL5PR3UyfTWvdlk-Qi-dPtJmjTj-2YIMMf



import Foundation
import FirebaseDatabase
import FirebaseAuth
import MessageKit
import CoreLocation

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

// for database.child, the child does not allow special char like "." and "@"
// so we need to do some sort of replacements to the email so that we can put it in the database
// in the database the emails will have "-" insted of "."
// in the database the emails will have "-" insted of "@"

// MARK: - Functions to Manage the Accounts
extension DatabaseManager {
    
    // this is to make sure that people cannot register with the same email twice
    // the snapshot is getting the data from the data base
    // if database.child(email) is already in database thus we do not want to create the account
    public func userExistis(with email: String,
                            completion: @escaping ((Bool) -> Void)){
        
        
        
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        database.child(safeEmail).observeSingleEvent(of: .value, with: { snapshot in
            guard snapshot.value as? [String: Any] != nil else {
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
    
    // age, gender, school, major, relationshipType, party?
    
    //MARK- New insert
    public func insertUser(with user: AppUser, completion: @escaping (Bool) -> Void) {
        let currUser = Auth.auth().currentUser
        let uid = currUser!.uid
        database.child(user.safeEmail).setValue([
            FBKeys.User.firstName: user.firstName,
            FBKeys.User.lastName: user.lastName,
            FBKeys.User.age: user.age,
            FBKeys.User.school: user.school,
            FBKeys.User.major: user.major,
            FBKeys.User.gender: user.gender,
            FBKeys.User.sexuality: user.sexuality,
            FBKeys.User.email: user.safeEmail,
            FBKeys.User.name: user.firstName + " " + user.lastName
            // FBKeys.User.imgs: user.imgs,
            // FBKeys.User.bio: user.bio,
            // FBKeys.User.swipedBy: user.swipedBy
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
                            FBKeys.User.name: user.name,
                            FBKeys.User.age: user.age,
                            FBKeys.User.school: user.school,
                            FBKeys.User.major: user.major,
                            FBKeys.User.gender: user.gender,
                            FBKeys.User.sexuality: user.sexuality,
                            FBKeys.User.email: user.safeEmail,
                            FBKeys.User.firstName: user.firstName,
                            FBKeys.User.lastName: user.lastName
                        ]
                        // usersCollection.append(newElement)
                        // changed from usercollection to new element
                        self.database.child("users/\(uid)").setValue(newElement, withCompletionBlock: { error, _ in
                            guard error == nil else {
                                completion(false)
                                return
                            }
                            
                            completion(true)
                        })
                    }
                    else {
                        // create that array of the users
                        let newCollection: [String: String] =
                            [
                                FBKeys.User.name: user.name,
                                FBKeys.User.age: user.age,
                                FBKeys.User.school: user.school,
                                FBKeys.User.major: user.major,
                                FBKeys.User.gender: user.gender,
                                FBKeys.User.sexuality: user.sexuality,
                                FBKeys.User.email: user.safeEmail,
                                FBKeys.User.firstName: user.firstName,
                                FBKeys.User.lastName: user.lastName
                        ]
                        
                        
                        self.database.child("users/\(uid)").setValue(newCollection, withCompletionBlock: { error, _ in
                            
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
        let parentRef = database.child("users")
        var userList = [[String:String]]()
        
        parentRef.observeSingleEvent(of: .value) { snapshot in
            print(snapshot)
            // print("snapshot key : \(snapshot.key)")
            
            for user_child in snapshot.children {
                let user_snap = user_child as! DataSnapshot
                let value = user_snap.value as! [String:String]
                let uid = user_snap.key
                // variables
                let name: String = value["name"]!
                let email: String = value["email"]!
                let age: String = value["age"]!
                let gender: String = value["gender"]!
                let sexualty: String = value["sexuality"]!
                let school: String = value["school"]!
                let major: String = value["major"]!
                
                let userDict = ["uid": uid,
                                "name": name,
                                "email": email,
                                "gender": gender,
                                "sexuality": sexualty,
                                "school": school,
                                "major": major,
                                "age": age]
                print(userDict)
                userList.append(userDict)
                
            }
            print("userList \(userList)")
            completion(.success(userList))
        }
        completion(.failure(DatabaseError.failedToFetch))
    }
    
    //    MARK: - SWIPE FUNCS

    public func swipe(with targetUserUID: String, completion: @escaping (Bool) -> Void) {
        // first, get uid of current user
        guard let curUser = FirebaseAuth.Auth.auth().currentUser?.uid else { return }
        let parentRef = database.child("users")
        
        // second, get uid of swiped user (the argument)
        
        // third, append current uid to swiped uid swipedBy collection
        parentRef.child("\(targetUserUID)/swipedBy").observeSingleEvent(of: .value, with: { snapshot in
            if var swipeCollection = snapshot.value as? [String] {
                // append within user to swipedBy array
                swipeCollection.append(curUser)
                
                self.database.child("users").child("\(targetUserUID)/swipedBy").setValue(swipeCollection, withCompletionBlock: { error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    
                    completion(true)
                })
            }
            else {
                // create that array
                //MARK ADD all the info to the new collection
                let newCollection: [String] = [
                    curUser
                ]
                
                self.database.child("users").child("\(targetUserUID)/swipedBy").setValue(newCollection, withCompletionBlock: { error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    
                    completion(true)
                })
            }
        })
    }
    
    
    public func getMySwipes(completion: @escaping (Result<[String], Error>) -> Void) {
        guard let curUser = FirebaseAuth.Auth.auth().currentUser?.uid else { return }
        let parentRef = database.child("users")
        var swipeList = [String]()
        
        parentRef.child("\(curUser)/swipedBy").observeSingleEvent(of: .value) { snapshot in
            let value = snapshot.value as! [String:String]
            swipeList = Array(value.values)
            print("swipeList \(swipeList)")
            completion(.success(swipeList))
            return
        }
        completion(.failure(DatabaseError.failedToFetch))
        return
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
                if var conversations = snapshot.value as? [[String: Any]] {
                    // append the message to the conversation
                    conversations.append(recipient_newConversationData)
                    self?.database.child("\(otherUserEmail)/conversations").setValue(conversations)
                    
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
                                                         conversationID: conversationID,
                                                         firstMessage: firstMessage,
                                                         completion: completion)
                    
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
                                                         conversationID: conversationID,
                                                         firstMessage: firstMessage,
                                                         completion: completion)
                    
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
                
                var kind: MessageKind?
                if type == "photo" {
                    // photo
                    guard let imageUrl = URL(string: content),
                        let placeHolder = UIImage(systemName: "plus") else {
                            return nil
                    }
                    let media = Media(url: imageUrl,
                                      image: nil,
                                      placeholderImage: placeHolder,
                                      size: CGSize(width: 300, height: 300))
                    kind = .photo(media)
                }
                else if type == "video" {
                    // photo
                    guard let videoUrl = URL(string: content),
                        let placeHolder = UIImage(named: "video_placeholder") else {
                            return nil
                    }
                    let media = Media(url: videoUrl,
                                      image: nil,
                                      placeholderImage: placeHolder,
                                      size: CGSize(width: 300, height: 300))
                    kind = .video(media)
                }
                    else if type == "location" {
                        let locationComponents = content.components(separatedBy: ",")
                        guard let longitude = Double(locationComponents[0]),
                            let latitude = Double(locationComponents[1]) else {
                            return nil
                        }
                        print("Rendering location; long=\(longitude) | lat=\(latitude)")
                        let location = Location(location: CLLocation(latitude: latitude, longitude: longitude),
                                                size: CGSize(width: 300, height: 300))
                        kind = .location(location)
                    }
                else {
                    kind = .text(content)
                }
                
                guard let finalKind = kind else {
                    return nil
                }
                
                let sender = Sender(photoURL: "",
                                    senderId: senderEmail,
                                    displayName: name)
                
                return Message(sender: sender,
                               messageId: messageID,
                               sentDate: date,
                               kind: finalKind)
            })
            
            completion(.success(messages))
        })
    }
    
    
    /// sending message to a person in an exsisting convo
    // READ THIS PLEASE
    // this looks terrible right now and needs cleaning up, but the functionality is there, there is just alot of redundent code
    // the code is really long because there were a lot of issues when the user deletes a convo, starting a new convo was difficult
    // or users could start multiple convo with the same person
    // we can now search for users we already have a convo with, and the app does not start a new convo
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
            case .photo(let mediaItem):
                if let targetUrlString = mediaItem.url?.absoluteString {
                    message = targetUrlString
                }
                break
            case .video(let mediaItem):
                if let targetUrlString = mediaItem.url?.absoluteString {
                    message = targetUrlString
                }
            case .location(let locationData):
            let location = locationData.location
            message = "\(location.coordinate.longitude),\(location.coordinate.latitude)"
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
            
            //MARK- IDK WHY WE DID THIS AGAIN
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
            
            // we are writing to the database
            strongSelf.database.child("\(conversation)/messages").setValue(currentMessages) {error, _ in
                guard error == nil else {
                    completion(false)
                    return
                }
                
                // this is to update the latest messege sent by the user
                strongSelf.database.child("\(currentEmail)/conversations").observeSingleEvent(of: .value, with: { snapshot in
                    var databaseEntryConversations = [[String: Any]]()
                    
                    // the most recent value sent
                    let updatedValue: [String: Any] = [
                        "date": dateString,
                        "is_read": false,
                        "message": message,
                        
                    ]
                    
                    // if the current user has conversations already
                    if var currentUserConversations = snapshot.value as? [[String: Any]] {
                        var targetConversation: [String: Any]?
                        var position = 0
                        
                        // iterating over the conversations
                        for conversationDictionary in currentUserConversations {
                            if let currentId = conversationDictionary["id"] as? String, currentId == conversation {
                                targetConversation = conversationDictionary
                                break
                            }
                            position += 1
                        }
                        
                        // found the target conversation
                        if var targetConversation = targetConversation {
                            targetConversation["latest_message"] = updatedValue
                            currentUserConversations[position] = targetConversation
                            databaseEntryConversations = currentUserConversations
                        }
                        else {
                            let newConversationData: [String: Any] = [
                                "id": conversation,
                                "other_user_email": DatabaseManager.safeEmail(emailAddress: otherUserEmail),
                                "name": name,
                                "latest_message": updatedValue
                            ]
                            currentUserConversations.append(newConversationData)
                            databaseEntryConversations = currentUserConversations
                        }
                    }
                    else {
                        let newConversationData: [String: Any] = [
                            "id": conversation,
                            "other_user_email": DatabaseManager.safeEmail(emailAddress: otherUserEmail),
                            "name": name,
                            "latest_message": updatedValue
                        ]
                        databaseEntryConversations = [
                            newConversationData
                        ]
                    }
                    
                    strongSelf.database.child("\(currentEmail)/conversations").setValue(databaseEntryConversations, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        
                        // we have to also update for the recipient
                        // this funciton finds the other user and writes/ edits the database for the other user as well
                        strongSelf.database.child("\(otherUserEmail)/conversations").observeSingleEvent(of: .value, with: { snapshot in
                            let updatedValue: [String: Any] = [
                                "date": dateString,
                                "is_read": false,
                                "message": message
                            ]
                            var databaseEntryConversations = [[String: Any]]()
                            
                            guard let currentName = UserDefaults.standard.value(forKey: "name") as? String else {
                                return
                            }
                            
                            // the other user's data
                            if var otherUserConversations = snapshot.value as? [[String: Any]] {
                                var targetConversation: [String: Any]?
                                var position = 0
                                
                                for conversationDictionary in otherUserConversations {
                                    if let currentId = conversationDictionary["id"] as? String, currentId == conversation {
                                        targetConversation = conversationDictionary
                                        break
                                    }
                                    position += 1
                                }
                                
                                // got the target convo
                                if var targetConversation = targetConversation {
                                    targetConversation["latest_message"] = updatedValue
                                    otherUserConversations[position] = targetConversation
                                    databaseEntryConversations = otherUserConversations
                                }
                                else {
                                    // cound not find it
                                    let newConversationData: [String: Any] = [
                                        "id": conversation,
                                        "other_user_email": DatabaseManager.safeEmail(emailAddress: currentEmail),
                                        "name": currentName,
                                        "latest_message": updatedValue
                                    ]
                                    otherUserConversations.append(newConversationData)
                                    databaseEntryConversations = otherUserConversations
                                }
                            }
                            else {
                                // if the collection does not exist- user could have deleated it
                                let newConversationData: [String: Any] = [
                                    "id": conversation,
                                    "other_user_email": DatabaseManager.safeEmail(emailAddress: currentEmail),
                                    "name": currentName,
                                    "latest_message": updatedValue
                                ]
                                databaseEntryConversations = [
                                    newConversationData
                                ]
                            }
                            
                            // here we write to the database after having the correct info
                            strongSelf.database.child("\(otherUserEmail)/conversations").setValue(databaseEntryConversations, withCompletionBlock: { error, _ in
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
    }
    
    /// to delete a conversation
    public func deleteConversation(conversationId: String, completion: @escaping (Bool) -> Void) {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        // getting the safe email for the user
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        
        // print("Deleting conversation with id: \(conversationId)")
        
        // Get all conversations for current user
        // delete conversation in collection with target id
        // reset those conversations for the user in database
        
        // getting the reference to the conversation
        let ref = database.child("\(safeEmail)/conversations")
        ref.observeSingleEvent(of: .value) { snapshot in
            if var conversations = snapshot.value as? [[String: Any]] {
                var positionToRemove = 0
                for conversation in conversations {
                    if let id = conversation["id"] as? String,
                        id == conversationId {
                        print("The conversion to delete has been found")
                        break
                    }
                    positionToRemove += 1
                }
                
                conversations.remove(at: positionToRemove)
                ref.setValue(conversations, withCompletionBlock: { error, _  in
                    guard error == nil else {
                        completion(false)
                        print("could not delete the convo in firebase")
                        return
                    }
                    print("deleted conversaiton")
                    completion(true)
                })
            }
        }
    }
    
    // this is a helper function to check to see if a conversation exists givent he two users
    // basically we are reading the database and searching for the unique ids and if it is there then the convo exists
    public func conversationExists(iwth targetRecipientEmail: String, completion: @escaping (Result<String, Error>) -> Void) {
        let safeRecipientEmail = DatabaseManager.safeEmail(emailAddress: targetRecipientEmail)
        guard let senderEmail = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        let safeSenderEmail = DatabaseManager.safeEmail(emailAddress: senderEmail)

        database.child("\(safeRecipientEmail)/conversations").observeSingleEvent(of: .value, with: { snapshot in
            guard let collection = snapshot.value as? [[String: Any]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }

            // iterate through the conversations and find the conversation with the target sender
            if let conversation = collection.first(where: {
                guard let targetSenderEmail = $0["other_user_email"] as? String else {
                    return false
                }
                return safeSenderEmail == targetSenderEmail
            }) {
                // getting the chat id of the conversation
                guard let id = conversation["id"] as? String else {
                    completion(.failure(DatabaseError.failedToFetch))
                    return
                }
                // if we succeed, we are giving back the id
                completion(.success(id))
                return
            }
            // if we could not get the id, we are giving back an error
            completion(.failure(DatabaseError.failedToFetch))
            return
        })
    }
    
    
    
}




struct AppUser {
    
    let firstName: String
    let lastName: String
    let emailAddress: String
    let uid: String
    // Mark fix to int for age
    let age: String
    let gender: String
    let sexuality: String
    let school: String
    let major: String
    let name: String
    // var name = firstName + " " + lastName
    
    // opts
    var imgs: [Int:UIImage] = [:]
    var bio: String = ""
    
    
    
    // matching
    var swipedBy: [String] = []
    
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
