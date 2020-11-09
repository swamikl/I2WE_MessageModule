//
//  ChatViewController.swift
//  Messenger
//
//  Created by Swamik Lamichhane on 11/7/20.
//  Copyright © 2020 Swamik Lamichhane. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView

struct Message: MessageType {
    public var sender: SenderType
    public var messageId: String
    public var sentDate: Date
    public var kind: MessageKind
}

extension MessageKind {
    var messageKindString: String {
        switch self {
            
        case .text(_):
            return "text"
        case .attributedText(_):
            return "attributed_text"
        
        // probably not implimenting the following kinds of messages
        case .photo(_):
            return "photo"
        case .video(_):
            return "video"
        case .location(_):
            return "location"
        case .emoji(_):
            return "emoji"
        case .audio(_):
            return "audio"
        case .contact(_):
            return "contact"
        case .linkPreview(_):
            return "linkPreview"
        case .custom(_):
            return "custom"
        }
    }
}


struct Sender: SenderType{
    public var photoURL: String
    public var senderId: String
    public var displayName: String
}

class ChatViewController: MessagesViewController {
    
    public static let dateFormatter: DateFormatter = {
        let formattre = DateFormatter()
        formattre.dateStyle = .medium
        formattre.timeStyle = .long
        formattre.locale = .current
        return formattre
    }()

    
    public var isNewConversation = false
    
    // the other user you are talking to
    public let otherUserEmail: String
    
    private var messages = [Message]()
    
    private var selfSender: Sender? {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return nil
        }
        return Sender(photoURL: "",
               senderId: email,
               displayName: "swam")
    }
        
        
        init(with email: String) {
            self.otherUserEmail = email
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            view.backgroundColor = .red
            
            messagesCollectionView.messagesDataSource = self
            messagesCollectionView.messagesLayoutDelegate = self
            messagesCollectionView.messagesDisplayDelegate = self
            messageInputBar.delegate = self
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            messageInputBar.inputTextView.becomeFirstResponder()
        }
    }
    
    extension ChatViewController: InputBarAccessoryViewDelegate {
        
        func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
            guard !text.replacingOccurrences(of: " ", with: "").isEmpty,
                let selfSender = self.selfSender,
                let messageId = createMessageId() else {
                return
            }
            
            // send the message
            if isNewConversation {
                // create new convo in database
                let message = Message(sender: selfSender,
                                      messageId: messageId,
                                      sentDate: Date(),
                                      kind: .text(text))
                DatabaseManager.shared.createNewConversation(with: otherUserEmail, firstMessage: message, completion: {success in
                    if success {
                        print("message sent")
                    }
                    else {
                        print("faield ot send")
                    }
                })
            }
            else {
                // append to exsisting conco data
            }
            
        }
        
        private func createMessageId() -> String? {
            // making a random message id with date, otherUesrEmail, senderEmail, and a randomInt
            
            // getting the email of the person currently using the app
            guard let currentUserEmail = UserDefaults.standard.value(forKey: "email") as? String else {
                return nil
            }

            let safeCurrentEmail = DatabaseManager.safeEmail(emailAddress: currentUserEmail)

            let dateString = Self.dateFormatter.string(from: Date())
            let newIdentifier = "\(otherUserEmail)_\(safeCurrentEmail)_\(dateString)"

            print("created message id: \(newIdentifier)")

            return newIdentifier
        }
        
        
        
    }
    
    
    
    extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
        func currentSender() -> SenderType {
           if let sender = selfSender {
                return sender
            }

            fatalError("Self Sender is nil, email should be cached")
            return Sender(photoURL: "", senderId: "12", displayName: "")
        }
        
        func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
            return messages[indexPath.section]
        }
        
        func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
            return messages.count
        }
        
        
}
