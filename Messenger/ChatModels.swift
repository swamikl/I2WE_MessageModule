////
////  ChatModels.swift
////  Messenger
////
////  Created by Swamik Lamichhane on 11/21/20.
////  Copyright © 2020 Swamik Lamichhane. All rights reserved.
//// Followed a tutorial for a IOS messenging app to learn how to use swift and building an IOS app
//// https://www.youtube.com/playlist?list=PL5PR3UyfTWvdlk-Qi-dPtJmjTj-2YIMMf
////
//
//import Foundation
//import CoreLocation
//import MessageKit
//
//struct Message: MessageType {
//    public var sender: SenderType
//    public var messageId: String
//    public var sentDate: Date
//    public var kind: MessageKind
//}
//
//
//extension MessageKind {
//    var messageKindString: String {
//        switch self {
//        case .text(_):
//            return "text"
//        case .attributedText(_):
//            return "attributed_text"
//        case .photo(_):
//            return "photo"
//        case .video(_):
//            return "video"
//        case .location(_):
//            return "location"
//        case .emoji(_):
//            return "emoji"
//        case .audio(_):
//            return "audio"
//        case .contact(_):
//            return "contact"
//        case .custom(_):
//            return "custom"
//        case .linkPreview(_):
//            return "link Preview"
//        }
//    }
//}
//
//struct Sender: SenderType {
//    public var photoURL: String
//    public var senderId: String
//    public var displayName: String
//}
//
//struct Media: MediaItem {
//    var url: URL?
//    var image: UIImage?
//    var placeholderImage: UIImage
//    var size: CGSize
//}
//
//struct Location: LocationItem {
//    var location: CLLocation
//    var size: CGSize
//}
