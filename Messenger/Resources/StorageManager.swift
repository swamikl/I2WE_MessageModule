//
//  StorageManager.swift
//  Messenger
//
//  Created by Swamik Lamichhane on 11/7/20.
//  Copyright © 2020 Swamik Lamichhane. All rights reserved.
// Followed a tutorial for a IOS messenging app to learn how to use swift and building an IOS app
// https://www.youtube.com/playlist?list=PL5PR3UyfTWvdlk-Qi-dPtJmjTj-2YIMMf

import Foundation
import FirebaseStorage

final class StorageManager {
    
    static let shared = StorageManager()
    
    private let storage = Storage.storage().reference()
    
    public typealias UploadPictureCompletion = (Result<String, Error>)-> Void
    /// Uploads picture to firebase storage and returns completion with url string to download
    public func uploadProfilePicture (with data: Data, fileName: String, completion: @escaping UploadPictureCompletion){
        
        storage.child("images/\(fileName)").putData(data, metadata: nil, completion: {metadata, error in
            guard error == nil else {
                // failed
                print ("Failed to upload data to firebase for picture")
                completion(.failure(StorageErrors.failedTOUpload))
                return
            }
            
            self.storage.child("images/\(fileName)").downloadURL(completion: { url, error in
                guard let url = url else {
                    print ("Failed to get the download URL")
                    completion(.failure(StorageErrors.failedToGetDownloadUrl))
                    return
                }
                
                let urlString = url.absoluteString
                print ("download url returned: \(urlString)")
                completion(.success(urlString))
            })
            
        })
        
    }
    
    public enum StorageErrors: Error{
        case failedTOUpload
        case failedToGetDownloadUrl
    }
    
    public func downloadURL(for path: String, completion: @escaping (Result<URL, Error>) -> Void) {
        let reference = storage.child(path)

        reference.downloadURL(completion: { url, error in
            guard let url = url, error == nil else {
                completion(.failure(StorageErrors.failedToGetDownloadUrl))
                return
            }

            completion(.success(url))
        })
    }
    
}
