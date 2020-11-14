//
//  FBActions.swift
//  I2WE
//
//  Created by Jaden Kim on 11/8/20.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct FBActions {
    
    // MARK: - FB Firestore User update
    static func updateUser(password:String,
                           email:String,
                           firstName: String,
                           lastName: String,
                           age: Int,
                           imgs: [Int:UIImage] = [:],
                           pronouns: Int = -1,
                           school: Int = -1,
                           bio: String = "",
                           emoji: String = "",
                           zodiac: Int = -1,// -1=none
                           mbti: Int = -1 // Meyers-Briggs
                           ) {
        let data: [String : Any] = [
                                FBKeys.User.email: email,
                                FBKeys.User.firstName: firstName,
                                FBKeys.User.lastName: lastName,
                                FBKeys.User.age: age,
                                FBKeys.User.imgs: imgs,
                                FBKeys.User.pronouns: pronouns,
                                FBKeys.User.school: school,
                                FBKeys.User.bio: bio,
                                FBKeys.User.emoji: emoji,
                                FBKeys.User.zodiac: zodiac,
                                FBKeys.User.mbti: mbti
                                ]
        
        Firestore.firestore().collection(FBKeys.CollectionPath.users).document(Auth.auth().currentUser!.uid).setData(data) { err in
            if let err = err {
                print("Error updating user info")
            }
            else {
                print("Successfully updated!")
            }
        }
    }
    
    // MARK: - FB Firestore User fetch
    static func getCurUser() -> [String: Any] {
        var data: [String: Any] = [:]
        let cur = Auth.auth().currentUser!.uid
        Firestore
            .firestore()
            .collection(FBKeys.CollectionPath.users)
            .document(cur)
            .getDocument() { (doc, err) in
            if let doc = doc, doc.exists {
                data = doc.data()!
                } else {
                print("Document does not exist")
            }
        }
        return data
    }
    
//    // MARK: - FB Firestore User fetch
//    static func getCurUser() -> Int {
//        Firestore.firestore().collection(FBKeys.CollectionPath.users).document(Auth.auth().currentUser!.uid).getDocument() { (doc, err) in
//            if let doc = doc, doc.exists {
//                let dataDescription = doc.data().map(String.init(describing:)) ?? "nil"
//                        print("Document data: \(dataDescription)")
//                print("Good doc!")
//                } else {
//                print("Document does not exist")
//            }
//        }
//        return 0
//    }
    
//    // MARK: - FB Firestore User search
//    static func searchUsers(data: [String: [Any]]) -> [String] {
//        // take an array of search parameter arrays and returns an array of all matching users
//        var results: [String] = []
//
//        Firestore
//            .firestore()
//            .collection(FBKeys.CollectionPath.users)
//
//            //AGE PREF
////            .whereField(FBKeys.User.age, in: data[FBKeys.User.agePref]!)
//
//            //GENDER PREF
//            .whereField(FBKeys.User.pronouns, in: data[FBKeys.User.genderPref]!)
//
//            //LOC PREF
//            .whereField(FBKeys.User.loc, isEqualTo: data[FBKeys.User.locPref]!)
//
//            //MBTI PREF
//            .whereField(FBKeys.User.mbti, in: data[FBKeys.User.mbtiPref]!)
//
//            //ZODIAC PREF
//            .whereField(FBKeys.User.zodiac, isEqualTo: data[FBKeys.User.zodPref]!)
//
//            //EMOJI PREF
//            .whereField(FBKeys.User.emoji, isEqualTo: data[FBKeys.User.emojiPref]!)
//
//            .getDocuments() { (qSnapshot, err) in
//                if let err = err {
//                    print("Error getting users: \(err)")
//                } else {
//                    for document in qSnapshot!.documents {
//                        results.append(document.documentID)
//                        print("\(document.documentID) => \(document.data())")
//                    }
//                }
//            }
//        return results
//    }
//
//    // MARK: - FB Firestore User swipe
//    static func swipe(uid: String, data: [String]) {
//        // takes a uid(1) and an array of uids(2)
//        // adds all 2s to 1's swiped array and adds 1 to all 2s' swipedBy arrays
//        let cur = Auth.auth().currentUser!.uid
//        Firestore
//            .firestore()
//            .collection(FBKeys.CollectionPath.users)
//            .document(cur)
//            .getDocument() { (doc, err) in
//            if let doc = doc, doc.exists {
//                data = doc.data()!
//                } else {
//                print("Document does not exist")
//            }
//        }
//        return data
//    }
//
//    // MARK: - FB Firestore User matches
//    static func getMatches(uid: String, data: [String]) {
//        // checks swiped array against swipedBy array to find all matches
//        var data: [String: Any] = [:]
//        let cur = Auth.auth().currentUser!.uid
//        Firestore
//            .firestore()
//            .collection(FBKeys.CollectionPath.users)
//            .document(cur)
//            .getDocument() { (doc, err) in
//            if let doc = doc, doc.exists {
//                data = doc.data()!
//                } else {
//                print("Document does not exist")
//            }
//        }
//        return data
//    }
}
