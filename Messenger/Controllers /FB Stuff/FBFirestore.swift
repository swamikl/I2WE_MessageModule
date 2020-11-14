////
////  FBFirestore.swift
////  I2WE
////
////  Created by Jaden Kim on 11/7/20.
////
//
//import Firebase
//import FirebaseFirestore
//import SwiftUI
//
//enum FBFirestore {
//    static func retrieveFBUser(uid: String, completion: @escaping (Result<FBUser, Error>) -> ()) {
//        let reference = Firestore
//            .firestore()
//            .collection(FBKeys.CollectionPath.users)
//            .document(uid)
//        getDocument(for: reference) { (result) in
//                switch result {
//                case .success(let data):
//                    guard let user = FBUser(documentData: data) else {
//                        completion(.failure(FirestoreError.noUser))
//                        return
//                    }
//                    completion(.success(user))
//                case .failure(let err):
//                    completion(.failure(err))
//                }
//        }
//    }
//
//    static func mergeFBUser(_ data: [String: Any], uid: String, completion: @escaping (Result<Bool, Error>) -> ()) {
//        let reference = Firestore
//            .firestore()
//            .collection(FBKeys.CollectionPath.users)
//            .document(uid)
//        reference.setData(data, merge: true) { (err) in
//            if let err = err {
//                completion(.failure(err))
//                return
//            }
//            completion(.success(true))
//        }
//    }
//
//    fileprivate static func getDocument(for reference: DocumentReference, completion: @escaping (Result<[String : Any], Error>) -> ()) {
//        reference.getDocument { (documentSnapshot, err) in
//            if let err = err {
//                completion(.failure(err))
//                return
//            }
//            guard let documentSnapshot = documentSnapshot else {
//                completion(.failure(FirestoreError.noDocumentSnapshot))
//                return
//            }
//            guard let data = documentSnapshot.data() else {
//                completion(.failure(FirestoreError.noSnapshotData))
//                return
//            }
//            completion(.success(data))
//        }
//    }
//}
