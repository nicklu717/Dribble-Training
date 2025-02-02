//
//  StorageManager.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/17.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import FirebaseStorage

class StorageManager {
    
    static let shared = StorageManager()
    
    // MARK: - Property Declaration
    
    private let storageReference = Storage.storage().reference()
    
    private let pictureName = "profile.jpeg"
    
    // MARK: - Instance Method
    
    func getProfilePicture(forID id: ID, completion: @escaping (Result<URL, Error>) -> Void) {
        
        let reference = storageReference.child(id).child(pictureName)
            
        reference.downloadURL { (url, error) in
                
            if let error = error {
                
                completion(.failure(error))
            }
            
            if let url = url {
                
                completion(.success(url))
            }
        }
    }
    
    func uploadScreenShot(fileName: String,
                          image: UIImage,
                          completion: @escaping (Result<URL, Error>) -> Void) {
        
        guard let currentUser = AuthManager.shared.currentUser else { return }
        
        guard let data = image.jpegData(compressionQuality: 0.3) else { return }
        
        let reference = storageReference.child(currentUser.id).child(Folder.trainingVideo).child(fileName)
        
        let metadata = StorageMetadata()
        
        metadata.contentType = ContentType.jpeg
        
        reference.putData(data, metadata: metadata) { (_, error) in
            
            if let error = error {
                
                completion(.failure(error))
                
                return
            }
            
            reference.downloadURL { (url, error) in
                
                if let error = error {
                    
                    completion(.failure(error))
                }
                
                if let url = url {
                    
                    completion(.success(url))
                }
            }
        }
    }
    
    func removeScreenShot(fileName: String) {
        
        guard let currentUser = AuthManager.shared.currentUser else { return }
        
        let reference = storageReference.child(currentUser.id).child(Folder.trainingVideo).child(fileName)
            
        reference.delete { (error) in
                
            if let error = error {
                
                print(error)
            }
        }
    }
    
    func uploadVideo(fileName: String,
                     url: URL,
                     completion: @escaping (Result<URL, Error>) -> Void) {
        
        guard let currentUser = AuthManager.shared.currentUser else { return }
        
        let reference = storageReference.child(currentUser.id).child(Folder.trainingVideo).child(fileName)
        
        let metadata = StorageMetadata()
        
        metadata.contentType = ContentType.mp4
        
        reference.putFile(from: url, metadata: metadata) { (_, error) in
                
            if let error = error {
                
                completion(.failure(error))
                
                return
            }
            
            reference.downloadURL(completion: { (url, error) in
                
                if let error = error {
                    
                    completion(.failure(error))
                }
                
                if let url = url {
                    
                    completion(.success(url))
                }
            })
        }
    }
    
    private struct Folder {
        
        static let trainingVideo = "training_video"
    }
    
    private struct ContentType {
        
        static let jpeg = "image/jpeg"
        
        static let mp4 = "video/mp4"
    }
}
