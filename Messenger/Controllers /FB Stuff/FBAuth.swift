////
////  FBAuth.swift
////  Signin With Apple
////
////  Created by Stewart Lynch on 2020-03-18.
////  Copyright © 2020 CreaTECH Solutions. All rights reserved.
////
//
//import SwiftUI
//import FirebaseAuth
//import FirebaseFirestore
//import CryptoKit
//import AuthenticationServices
//
//struct FBAuth {
//    // MARK: - Sign In with Email functions
//
//    static func resetPassword(email:String, resetCompletion:@escaping (Result<Bool,Error>) -> Void) {
//        Auth.auth().sendPasswordReset(withEmail: email, completion: { (error) in
//            if let error = error {
//                resetCompletion(.failure(error))
//            } else {
//                resetCompletion(.success(true))
//            }
//        }
//        )}
//
//    static func authenticate(withEmail email :String,
//                             password:String,
//                             completionHandler:@escaping (Result<Bool, EmailAuthError>) -> ()) {
//        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
//            // check the NSError code and convert the error to an AuthError type
//            var newError:NSError
//            if let err = error {
//                newError = err as NSError
//                var authError:EmailAuthError?
//                switch newError.code {
//                case 17009:
//                    authError = .incorrectPassword
//                case 17008:
//                    authError = .invalidEmail
//                case 17011:
//                    authError = .accoundDoesNotExist
//                default:
//                    authError = .unknownError
//                }
//                completionHandler(.failure(authError!))
//            } else {
//                completionHandler(.success(true))
//            }
//        }
//    }
//
//    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
//    static func randomNonceString(length: Int = 32) -> String {
//        precondition(length > 0)
//        let charset: Array<Character> =
//            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
//        var result = ""
//        var remainingLength = length
//
//        while remainingLength > 0 {
//            let randoms: [UInt8] = (0 ..< 16).map { _ in
//                var random: UInt8 = 0
//                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
//                if errorCode != errSecSuccess {
//                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
//                }
//                return random
//            }
//
//            randoms.forEach { random in
//                if length == 0 {
//                    return
//                }
//
//                if random < charset.count {
//                    result.append(charset[Int(random)])
//                    remainingLength -= 1
//                }
//            }
//        }
//
//        return result
//    }
//
//    static func sha256(_ input: String) -> String {
//        let inputData = Data(input.utf8)
//        let hashedData = SHA256.hash(data: inputData)
//        let hashString = hashedData.compactMap {
//            return String(format: "%02x", $0)
//        }.joined()
//
//        return hashString
//    }
//
//    // MARK: - FB Firestore User creation
//    static func createUser(withEmail email:String,
//                           firstName: String,
//                           lastName: String,
//                           age: Int,
//                           password:String,
//                           completionHandler:@escaping (Result<Bool,Error>) -> Void) {
//        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
//            if let err = error {
//                completionHandler(.failure(err))
//                return
//            }
//            guard let _ = authResult?.user else {
//                completionHandler(.failure(error!))
//                return
//            }
//            let data = FBUser.dataDict(uid: authResult!.user.uid,
//                                       email: authResult!.user.email!,
//                                       firstName: firstName,
//                                       lastName: lastName,
//                                       age: age
//            )
//
//            FBFirestore.mergeFBUser(data, uid: authResult!.user.uid) { (result) in
//                completionHandler(result)
//            }
//            completionHandler(.success(true))
//        }
//    }
//
//    // MARK: - Logout
//
//    static func logout(completion: @escaping (Result<Bool, Error>) -> ()) {
//        let auth = Auth.auth()
//        do {
//            try auth.signOut()
//            completion(.success(true))
//        } catch let err {
//            completion(.failure(err))
//        }
//    }
//
//}
