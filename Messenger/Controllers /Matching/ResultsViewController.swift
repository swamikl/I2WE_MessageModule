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
import FirebaseAuth
import MessageKit
import FirebaseDatabase

class ResultsViewController: UIViewController, UIScrollViewDelegate {
    var results = [[String:String]]()
//    var imgs:[UIImage] = [UIImage(named: "person")!]
    var count = 0
    var isTapped = false
    
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.isPagingEnabled = true
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 44)
        return scroll
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(scrollView)
        setupMyShit()
        
//        if results != [] {
//
//        } else {
//            view.backgroundColor = .white
//
//            let failImg = UIImageView()
//            failImg.frame = CGRect(x: 0, y: UIScreen.main.bounds.width/2 + 44, width: 38, height: 38)
//            failImg.image = UIImage(systemName: "face.dashed")
//            failImg.center.x = UIScreen.main.bounds.width/2
//
//            let failureView = UILabel()
//            failureView.frame = CGRect(x: 0, y: UIScreen.main.bounds.width/2 + 82, width: UIScreen.main.bounds.width, height: 40)
//            failureView.text = "No results"
//            failureView.textAlignment = .center
//
//            view.addSubview(failImg)
//            view.addSubview(failureView)
//        }
    }
}

extension ResultsViewController {
    
//    setUpMyShit() {
//
//        let tableView: UITableView = {
//            let table = UITableView()
//            table.register(ConversationTableViewCell.self,
//                                   forCellReuseIdentifier: ConversationTableViewCell.identifier)
//            return table
//        }()
//
//
//    }
//
    func setupMyShit() {

        for i in 0..<results.count {
            let xPosition = UIScreen.main.bounds.width * CGFloat(i) + 20
            
            let cardView = UIView()
            let titleLabel = UILabel()
            let genderLabel = UILabel()
            let schoolLabel = UILabel()
            let majorLabel = UILabel()
            let imageView = UIImageView()
//            let likeButton = UIButton()

            // THE STUFF THAT WORKS START

            // CARD
            cardView.frame = CGRect(x: xPosition, y: 20, width: scrollView.frame.width - 40, height: scrollView.frame.height * 0.7)
            cardView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cardView.layer.borderWidth = 5
            cardView.layer.borderColor = CGColor(gray: 0, alpha: 255)

            // IMAGE
            let pathRef = "images/\(DatabaseManager.safeEmail(emailAddress: results[count][FBKeys.User.email]!))_profile_picture.png"
            StorageManager.shared.downloadURL(for: pathRef, completion: { result in
                switch result {
                case .success(let url):
                    imageView.sd_setImage(with: url, completed: nil)
                case .failure:
                    imageView.image = UIImage(named: "profile")
                }
            })
            imageView.frame = CGRect(x: 0, y: 0, width: cardView.frame.size.width, height: cardView.frame.size.height * 0.75)
            imageView.contentMode = .scaleToFill

            // NAME
            print("this shit right here: \(results[count][FBKeys.User.name]!), \(results[count][FBKeys.User.age]!)")
            titleLabel.frame = CGRect(x: 13, y: imageView.frame.size.height, width: cardView.frame.size.width, height: 38)
            titleLabel.text = "\(results[count][FBKeys.User.name]!), \(results[count][FBKeys.User.age]!)"
            titleLabel.textColor = .black
            titleLabel.font = UIFont.systemFont(ofSize: 26, weight: .bold)

            // QUALIFIERS
            genderLabel.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            genderLabel.text = "\(results[count][FBKeys.User.gender]!), \(results[count][FBKeys.User.sexuality]!)"
            genderLabel.textColor = .white
            genderLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            genderLabel.frame = CGRect(x: 13, y: imageView.frame.size.height + titleLabel.frame.size.height + 3.5, width: titleLabel.frame.size.width, height: 22)
            genderLabel.sizeToFit()
            genderLabel.preferredMaxLayoutWidth = genderLabel.bounds.width + 5
            genderLabel.clipsToBounds = true
            genderLabel.layer.cornerRadius = 7
            genderLabel.textAlignment = NSTextAlignment.center

            majorLabel.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            majorLabel.text = "\(results[count][FBKeys.User.major]!)"
            majorLabel.textColor = .white
            majorLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            majorLabel.frame = CGRect(x: 13, y: imageView.frame.size.height + titleLabel.frame.size.height + genderLabel.frame.size.height + 7, width: titleLabel.frame.size.width, height: 22)
            majorLabel.sizeToFit()
            majorLabel.preferredMaxLayoutWidth = majorLabel.bounds.width + 5
            majorLabel.clipsToBounds = true
            majorLabel.layer.cornerRadius = 7
            majorLabel.textAlignment = NSTextAlignment.center

            switch results[count][FBKeys.User.school]! {
            case "Pomona":
                schoolLabel.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2362926926, blue: 0.6789116766, alpha: 1)
            case "CMC":
                schoolLabel.backgroundColor = #colorLiteral(red: 0.6380083686, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            case "Scripps":
                schoolLabel.backgroundColor = #colorLiteral(red: 0.1798692257, green: 0.4011206863, blue: 0.1712519072, alpha: 1)
            case "Pitzer":
                schoolLabel.backgroundColor = #colorLiteral(red: 0.8844142534, green: 0.4707125019, blue: 0.1712519072, alpha: 1)
            case "HMC":
                schoolLabel.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            default:
                schoolLabel.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            }
            schoolLabel.text = "\(results[count][FBKeys.User.school]!)"
            schoolLabel.textColor = .white
            schoolLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            schoolLabel.frame = CGRect(x: 13, y: imageView.frame.size.height + titleLabel.frame.size.height + genderLabel.frame.size.height + majorLabel.frame.size.height + 10.5, width: titleLabel.frame.size.width, height: 22)
            schoolLabel.sizeToFit()
            schoolLabel.preferredMaxLayoutWidth = majorLabel.bounds.width + 5
            schoolLabel.clipsToBounds = true
            schoolLabel.layer.cornerRadius = 7
            schoolLabel.textAlignment = NSTextAlignment.center

            // BUTTONS
//            likeButton.frame = CGRect(x: cardView.frame.size.width - 40, y: cardView.frame.size.height * 0.85, width: 40, height: 40)
//            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
//            likeButton.accessibilityLabel = DatabaseManager.safeEmail(emailAddress: results[count][FBKeys.User.email]!)
//            likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)

            cardView.addSubview(imageView)
            cardView.addSubview(titleLabel)
            cardView.addSubview(genderLabel)
            cardView.addSubview(majorLabel)
            cardView.addSubview(schoolLabel)
//            cardView.addSubview(likeButton)

            // THE STUFF THAT WORKS END

            scrollView.contentSize.width = scrollView.frame.width * CGFloat(i + 1)
            scrollView.addSubview(cardView)
            scrollView.delegate = self

            self.count += 1
        }

    }
    
//    @objc func likeButtonTapped(sender:UIButton) {
//
//        if !isTapped {
//            isTapped = true
//            DatabaseManager.shared.swipe(with: sender.accessibilityLabel!, completion: { success in
//                if success {
//                    print("Good.")
//                } else {
//                    print("Nope.")
//                }
//            })
//
//        }
//
//        let animator = UIViewPropertyAnimator(duration: 0.7, dampingRatio: 0.7) {
//            self.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
//        }
//        animator.startAnimation()
//        var myEmail: String = ""
//        var myName: String = ""
//
//        let database = Database.database().reference()
//        let curUid = Auth.auth().currentUser?.uid
//            database.child("users/\(curUid!)").observeSingleEvent(of: .value, with: { snapshot in
//                guard let value = snapshot.value as? [String: Any] else {
//                    return
//                }
//                myEmail = value[FBKeys.User.email] as! String
//                myName = value[FBKeys.User.name] as! String
//                return
//            })
//
//            let otherEmail = DatabaseManager.safeEmail(emailAddress: results[count][FBKeys.User.email]!)
//            let date = Date()
//            let textDate = ChatViewController.dateFormatter.string(from: Date())
//            let msgID = "\(otherEmail)_\(myEmail)_\(textDate)"
//
//            let sender = Sender(photoURL: "", senderId: myEmail, displayName: myName)
//            let newMsg = Message(sender: sender, messageId: msgID, sentDate: date, kind: .text("I like you! Let's talk. :)"))
//
//            DatabaseManager.shared.sendMessage(to: "conversation_\(msgID)", otherUserEmail: otherEmail, name: results[count][FBKeys.User.name]!, newMessage: newMsg, completion: { success in
//                if success {
//                    print("Nice one.")
//                } else {
//                    print("Fuck yourself.")
//                }
//            })
//
//        }
//    }
}
