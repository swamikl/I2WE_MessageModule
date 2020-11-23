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
    
    // so that users are forced to use shared and not make their own reference
    private init() {}
    
    private let storage = Storage.storage().reference()
    
    public typealias UploadPictureCompletion = (Result<String, Error>)-> Void
    /// Uploads picture to firebase storage and returns completion with url string to download
    public func uploadProfilePicture (with data: Data, fileName: String, completion: @escaping UploadPictureCompletion){
        
        storage.child("images/\(fileName)").putData(data, metadata: nil, completion: { [weak self] metadata, error in
            
            guard let strongSelf = self else {
                return
            }
            
            guard error == nil else {
                // failed
                print ("Failed to upload data to firebase for picture")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            
            strongSelf.storage.child("images/\(fileName)").downloadURL(completion: { url, error in
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
    
    /// Uploading the image that will be sent in a conversation message
    public func uploadMessagePhoto(with data: Data, fileName: String, completion: @escaping UploadPictureCompletion) {
        // the path of the image that is being stored into firebase storage
        storage.child("message_images/\(fileName)").putData(data, metadata: nil, completion: { [weak self] metadata, error in
            guard error == nil else {
                // failed to upload the image
                print("failed to upload data to firebase for picture")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }

            self?.storage.child("message_images/\(fileName)").downloadURL(completion: { url, error in
                        guard let url = url else {
                            print("Failed to get download url")
                            completion(.failure(StorageErrors.failedToGetDownloadUrl))
                            return
                        }

                        let urlString = url.absoluteString
                        print("download url returned: \(urlString)")
                        completion(.success(urlString))
                    })
                })
            }
    
    // to upload the videos to be sent through the chat
     public func uploadMessageVideo(with fileUrl: URL, fileName: String, completion: @escaping UploadPictureCompletion) {
           storage.child("message_videos/\(fileName)").putFile(from: fileUrl, metadata: nil, completion: { [weak self] metadata, error in
               guard error == nil else {
                   // failed
                   print("could not upload the video to firebase")
                   completion(.failure(StorageErrors.failedToUpload))
                   return
               }

               self?.storage.child("message_videos/\(fileName)").downloadURL(completion: { url, error in
                   guard let url = url else {
                       print("Failed to get download url")
                       completion(.failure(StorageErrors.failedToGetDownloadUrl))
                       return
                   }

                   let urlString = url.absoluteString
                   print("download url returned: \(urlString)")
                   completion(.success(urlString))
               })
           })
       }
    
    public enum StorageErrors: Error{
        case failedToUpload
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
