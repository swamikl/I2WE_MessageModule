//
//  ResultsViewController.swift
//  Messenger
//
//  Created by Jaden Kim on 11/21/20.
//  Copyright © 2020 Swamik Lamichhane. All rights reserved.
//

import UIKit
import SwiftUI
import FirebaseStorage

class ResultsViewController: UIViewController {
    var results = [[String:String]]()
    var count = 0
    let titleSize:CGFloat = 30
    let captionSize:CGFloat = 14
    let bioSize:CGFloat = 14

    let screenSize = UIScreen.main.bounds

    let cardView = UIView()
    let imageView = UIImageView()
    let nameLabel = UILabel()
    let genderLabel = UILabel()
    let sexLabel = UILabel()
    let schoolLabel = UILabel()
    let majorLabel = UILabel()
    let bioLabel = UILabel()

    var curImg = UIImage()

    override func loadView() {
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        var nextLabelX:CGFloat = 10
        let view = UIView()
        view.backgroundColor = .white

        // CARD VIEW
        self.cardView.backgroundColor = .white

        // IMAGE
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 3
        imageView.backgroundColor = .white
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.width/2
        imageView.image = curImg

//        let pathRef = "images/\(DatabaseManager.safeEmail(emailAddress: results[count][FBKeys.User.email]!))_profile_picture.png"
//        StorageManager.shared.downloadURL(for: pathRef, completion: { [weak self] result in
//            switch result {
//            case .success(let url):
//                self?.downloadImage(imageView: self!.imageView, url: url)
//            case .failure(let error):
//                print("Failed to get download url: \(error)")
//            }
//        })

        // NAME
        nameLabel.text = "\(results[count][FBKeys.User.name] ?? ""), \(results[count][FBKeys.User.age] ?? "")"
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.systemFont(ofSize: titleSize)
        nameLabel.frame = CGRect(x:10, y:imageView.intrinsicContentSize.height+10, width:nameLabel.intrinsicContentSize.width+5, height:nameLabel.intrinsicContentSize.height+5)
        nextLabelX = nextLabelX + nameLabel.intrinsicContentSize.width + CGFloat(15)

        // LABELS
        genderLabel.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        genderLabel.textColor = .white
        genderLabel.text = results[count][FBKeys.User.gender]
        genderLabel.textAlignment = .center
        genderLabel.font = UIFont.systemFont(ofSize: captionSize)
        genderLabel.frame = CGRect(x:10, y:imageView.intrinsicContentSize.height+nameLabel.intrinsicContentSize.height+20, width:genderLabel.intrinsicContentSize.width+5, height:genderLabel.intrinsicContentSize.height+5)
        nextLabelX = nextLabelX + genderLabel.intrinsicContentSize.width + CGFloat(15)

        sexLabel.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        sexLabel.textColor = .white
        sexLabel.text = results[count][FBKeys.User.sexuality]
        sexLabel.textAlignment = .center
        sexLabel.font = UIFont.systemFont(ofSize: captionSize)
        sexLabel.frame = CGRect(x:10, y:imageView.intrinsicContentSize.height+nameLabel.intrinsicContentSize.height+20, width:sexLabel.intrinsicContentSize.width+5, height:sexLabel.intrinsicContentSize.height+5)
        nextLabelX = nextLabelX + sexLabel.intrinsicContentSize.width + CGFloat(15)

        schoolLabel.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        schoolLabel.textColor = .white
        schoolLabel.text = results[count][FBKeys.User.school]
        schoolLabel.textAlignment = .center
        schoolLabel.font = UIFont.systemFont(ofSize: captionSize)
        schoolLabel.frame = CGRect(x:10, y:imageView.intrinsicContentSize.height+nameLabel.intrinsicContentSize.height+20, width:schoolLabel.intrinsicContentSize.width+5, height:schoolLabel.intrinsicContentSize.height+5)
        nextLabelX = nextLabelX + schoolLabel.intrinsicContentSize.width + CGFloat(15)

        majorLabel.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        majorLabel.textColor = .white
        majorLabel.text = results[count][FBKeys.User.major]
        majorLabel.textAlignment = .center
        majorLabel.font = UIFont.systemFont(ofSize: captionSize)
        majorLabel.frame = CGRect(x:10, y:imageView.intrinsicContentSize.height+nameLabel.intrinsicContentSize.height+20, width:majorLabel.intrinsicContentSize.width+5, height:majorLabel.intrinsicContentSize.height+5)
        nextLabelX = nextLabelX + majorLabel.intrinsicContentSize.width + CGFloat(15)

        // BIO
        bioLabel.text = results[count][FBKeys.User.bio]
        bioLabel.textAlignment = .center
        bioLabel.font = UIFont.systemFont(ofSize: captionSize)
        bioLabel.frame = CGRect(x:10, y:imageView.intrinsicContentSize.height+nameLabel.intrinsicContentSize.height+genderLabel.intrinsicContentSize.height+30, width:bioLabel.intrinsicContentSize.width+5, height:bioLabel.intrinsicContentSize.height+5)
        nextLabelX = nextLabelX + bioLabel.intrinsicContentSize.width + CGFloat(15)

        view.addSubview(cardView)
        cardView.addSubview(imageView)
        cardView.addSubview(nameLabel)
        self.view = view
    }

//    func downloadImage(imageView: UIImageView, url: URL) {
//        URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
//            guard let data = data, error == nil else {
//                return
//            }
//
//            DispatchQueue.main.async {
//                // converting the data to an image
//                let image = UIImage(data: data)
//                imageView.image = image
//            }
//        }).resume()
//    }

    func downloadImage() {
        let pathRef = "images/\(DatabaseManager.safeEmail(emailAddress: results[count][FBKeys.User.email]!))_profile_picture.png"
        let storageRef = Storage.storage().reference(withPath: pathRef)

        // Download the data, assuming a max size of 1MB (you can change this as necessary)
        storageRef.getData(maxSize: 20 * 1024 * 1024) { (data, error) -> Void in
            // Create a UIImage, add it to the array
            self.curImg = UIImage(data: data!)!
        }
    }
}
