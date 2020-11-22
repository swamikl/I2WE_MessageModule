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

class ResultsViewController: UIViewController, UIScrollViewDelegate {
    var results = [[String:String]]()
//    var imgs:[UIImage] = [UIImage(named: "person")!]
    var count = 0
    var navBarHeight: CGFloat = 44
    
    let cardView = UIView()
    let titleLabel = UILabel()
    let captionLabel = UILabel()
    let bioLabel = UILabel()
    let closeButton = UIButton()
    let likeButton = UIButton()
    let imageView = UIImageView()
    
    override func viewDidLoad() {
        navBarHeight = self.navigationController!.navigationBar.frame.height
        
        let view = UIView()
        view.backgroundColor = .white
        self.view = view
        view.addSubview(scrollView)
        setupImages()
    }
    
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.isPagingEnabled = true
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 44)
        return scroll
    }()
}

extension ResultsViewController {
    
    func setupImages(){
        
        for i in 0..<results.count {
            let xPosition = UIScreen.main.bounds.width * CGFloat(i)
            
            cardView.frame = CGRect(x: xPosition, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
            cardView.layer.cornerRadius = 14
            cardView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cardView.layer.shadowOpacity = 0.25
            cardView.layer.shadowOffset = CGSize(width: 0, height: 10)
            cardView.layer.shadowRadius = 10
            
            let pathRef = "images/\(DatabaseManager.safeEmail(emailAddress: results[count][FBKeys.User.email]!))_profile_picture.png"
            StorageManager.shared.downloadURL(for: pathRef, completion: { result in
                switch result {
                case .success(let url):
                    self.imageView.sd_setImage(with: url, completed: nil)
                    self.count += 1
                case .failure(let error):
                    print("Failed to get download url: \(error)")
                }
            })
            imageView.frame = CGRect(x: xPosition, y: 0, width: scrollView.frame.width, height: scrollView.frame.height / 2.5)
            imageView.contentMode = .scaleAspectFit
            
            titleLabel.frame = CGRect(x: xPosition, y: scrollView.frame.maxY - 10, width: scrollView.frame.width - 38, height: 38)
            titleLabel.text = results[count][FBKeys.User.name]
            titleLabel.textColor = .white
            titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
            
            bioLabel.frame = CGRect(x: xPosition, y: scrollView.frame.maxY + 50, width: scrollView.frame.width - 10, height: scrollView.frame.height - (scrollView.frame.height + 38))
            bioLabel.text = FBKeys.User.bio
            bioLabel.textColor = .black
            bioLabel.numberOfLines = 10
            bioLabel.alpha = 0
            
            closeButton.frame = CGRect(x: UIScreen.main.bounds.width - 10, y: 10, width: 28, height: 28)
            closeButton.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
            closeButton.layer.cornerRadius = 14
            closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
            closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
            closeButton.alpha = 0
            
            likeButton.frame = CGRect(x: UIScreen.main.bounds.width - 10, y: scrollView.frame.maxY - 10, width: 28, height: 28)
            likeButton.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
            likeButton.layer.cornerRadius = 14
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
            likeButton.alpha = 0
            
            cardView.addSubview(imageView)
            cardView.addSubview(titleLabel)
            cardView.addSubview(bioLabel)
            cardView.addSubview(closeButton)
            cardView.addSubview(likeButton)
            cardView.addSubview(bioLabel)
            
            scrollView.addSubview(cardView)
            scrollView.contentSize.width = scrollView.frame.width * CGFloat(i + 1)
            scrollView.delegate = self
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(cardViewTapped))
            cardView.addGestureRecognizer(tap)
            cardView.isUserInteractionEnabled = true
            
        }
        
    }
    
    @objc func cardViewTapped() {
        let animator = UIViewPropertyAnimator(duration: 0.7, dampingRatio: 0.7) {
            self.cardView.frame = CGRect(x: 0, y: 0, width: 375, height: 667)
            self.cardView.layer.cornerRadius = 0
            self.titleLabel.frame = CGRect(x: 20, y: 20, width: 374, height: 38)
            self.captionLabel.frame = CGRect(x: 20, y: 370, width: 272, height: 40)
            self.bioLabel.alpha = 1
            self.imageView.frame = CGRect(x: 0, y: 0, width: 375, height: 420)
            self.imageView.layer.cornerRadius = 0
            self.closeButton.alpha = 1
            self.likeButton.alpha = 1
        }
        animator.startAnimation()
    }
    
    @objc func closeButtonTapped() {
        let animator = UIViewPropertyAnimator(duration: 0.7, dampingRatio: 0.7) {
            self.cardView.frame = CGRect(x: 20, y: 255, width: 300, height: 250)
            self.cardView.layer.cornerRadius = 14
            self.titleLabel.frame = CGRect(x: 16, y: 16, width: 272, height: 38)
            self.captionLabel.frame = CGRect(x: 16, y: 204, width: 272, height: 40)
            self.bioLabel.alpha = 0
            self.imageView.frame = CGRect(x: 0, y: 0, width: 300, height: 250)
            self.imageView.layer.cornerRadius = 14
            self.closeButton.alpha = 0
        }
        animator.startAnimation()
    }
   
    @objc func likeButtonTapped() {
        DatabaseManager.shared.swipe(with: self.results[self.count][FBKeys.User.uid]!, completion: { success in
            if success {
                print("Good.")
            } else {
                print("Nope.")
            }
        })
        
        let animator = UIViewPropertyAnimator(duration: 0.7, dampingRatio: 0.7) {
            self.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            self.cardView.frame = CGRect(x: 20, y: 255, width: 300, height: 250)
            self.cardView.layer.cornerRadius = 14
            self.titleLabel.frame = CGRect(x: 16, y: 16, width: 272, height: 38)
            self.captionLabel.frame = CGRect(x: 16, y: 204, width: 272, height: 40)
            self.bioLabel.alpha = 0
            self.imageView.frame = CGRect(x: 0, y: 0, width: 300, height: 250)
            self.imageView.layer.cornerRadius = 14
            self.imageView.alpha = 50
            self.closeButton.alpha = 0
            self.likeButton.alpha = 0
        }
        animator.startAnimation()
    }
}
