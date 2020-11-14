//
//  FBUser.swift
//  I2WE
//
//  Created by Jaden Kim on 10/31/20.
//

import Foundation
import SwiftUI

struct FBUser {
    // reqs
    var uid: String
    var email: String
    var firstName: String
    var lastName: String
    var age: Int
    
    // opts
    var imgs: [Int:UIImage] = [:]
    var pronouns: Int = -1
    var school: Int = -1
    var bio: String = ""
    var emoji: String = ""
    var zodiac: Int = -1// -1=none
    var mbti: Int = -1 // Meyers-Briggs
    

    // matching
    var swiped: [String] = []
    var swipedBy: [String] = []
    
    // etc
    var description: String {
        return "uid: \(uid), email: \(email)"
    }
    
    init(uid: String, email: String, firstName: String, lastName: String, age: Int, imgs: [Int:UIImage] = [:], pronouns: Int = -1, school: Int = -1, bio: String = "", emoji: String = "", zodiac: Int = -1, mbti: Int = -1, genderPref: [Int] = [], agePref: [Int] = [], locPref: [[String]] = [], zodPref: [Int] = [], mbtiPref: [Int] = [], emojiPref: [String] = [], swiped: [String] = [], swipedBy: [String] = []) {
        self.uid = uid
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        
        self.imgs = imgs
        self.pronouns = pronouns
        self.school = school
        self.bio = bio
        self.emoji = emoji
        self.zodiac = zodiac
        self.mbti = mbti
        
        
        self.swiped = swiped
        self.swipedBy = swipedBy
        
    }

}

extension FBUser {
//    init?(documentData: [String : Any]) {
//        let uid = documentData[FBKeys.User.uid] as? String ?? ""
//        let email = documentData[FBKeys.User.email] as? String ?? ""
//        let firstName = documentData[FBKeys.User.firstName] as? String ?? ""
//        let lastName = documentData[FBKeys.User.lastName] as? String ?? ""
//        let age = documentData[FBKeys.User.age] as? Int ?? -1
//
//        let imgs = documentData[FBKeys.User.imgs] as? [Int:UIImage] ?? [:]
//        let pronouns = documentData[FBKeys.User.pronouns] as? Int ?? -1
//        let school = documentData[FBKeys.User.school] as? Int ?? -1
//        let bio = documentData[FBKeys.User.bio] as? String ?? ""
//        let emoji = documentData[FBKeys.User.emoji] as? String ?? ""
//        let zodiac = documentData[FBKeys.User.zodiac] as? Int ?? -1
//        let mbti = documentData[FBKeys.User.mbti] as? Int ?? -1
//
//        let genderPref = documentData[FBKeys.User.genderPref] as? [Int] ?? []
//        let agePref = documentData[FBKeys.User.agePref] as? [Int] ?? []
//        let locPref = documentData[FBKeys.User.locPref] as? [[String]] ?? []
//        let zodPref = documentData[FBKeys.User.zodPref] as? [Int] ?? []
//        let mbtiPref = documentData[FBKeys.User.mbtiPref] as? [Int] ?? []
//        let emojiPref = documentData[FBKeys.User.emojiPref] as? [String] ?? []
//
//        let swiped = documentData[FBKeys.User.swiped] as? [String] ?? []
//        let swipedBy = documentData[FBKeys.User.swipedBy] as? [String] ?? []
//
//        self.init(uid: uid,
//                  email: email,
//                  firstName: firstName,
//                  lastName: lastName,
//                  age: age,
//                  imgs: imgs,
//                  pronouns: pronouns,
//                  school: school,
//                  bio: bio,
//                  emoji: emoji,
//                  zodiac: zodiac,
//                  mbti: mbti,
//                  genderPref: genderPref,
//                  agePref: agePref,
//                  locPref: locPref,
//                  zodPref: zodPref,
//                  mbtiPref: mbtiPref,
//                  emojiPref: emojiPref,
//                  swiped: swiped,
//                  swipedBy: swipedBy
//        )
//    }
    
    static func dataDict(uid: String, email: String, firstName: String, lastName: String, age: Int, imgs: [Int:UIImage] = [:], pronouns: Int = -1, school: Int = -1, bio: String = "", emoji: String = "", zodiac: Int = -1, mbti: Int = -1, genderPref: [Int] = [], agePref: [Int] = [], locPref: [[String]] = [], zodPref: [Int] = [], mbtiPref: [Int] = [], emojiPref: [String] = [], swiped: [String] = [], swipedBy: [String] = []) -> [String: Any] {
        
        var data: [String: Any] = [:]
        
        // new user sign up ish
        if firstName != "" {
            data = [
                FBKeys.User.uid: uid,
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
                FBKeys.User.mbti: mbti,
                FBKeys.User.genderPref: genderPref,
                FBKeys.User.agePref: agePref,
                FBKeys.User.locPref: locPref,
                FBKeys.User.zodPref: zodPref,
                FBKeys.User.mbtiPref: mbtiPref,
                FBKeys.User.emojiPref: emojiPref,
                FBKeys.User.swiped: swiped,
                FBKeys.User.swipedBy: swipedBy
            ]
        } else {
            // returning user sign in ish
            data = [
                FBKeys.User.uid: uid,
                FBKeys.User.email: email
            ]
        }
        return data
    }
}

struct FBUser_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
