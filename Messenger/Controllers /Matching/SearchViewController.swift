//
//  SearchViewController.swift
//  Messenger
//
//  Created by Swamik Lamichhane on 11/10/20.
//  Copyright © 2020 Swamik Lamichhane. All rights reserved.
//

import UIKit
import JGProgressHUD

class SearchViewController: UIViewController {

    
    
    private let spinner = JGProgressHUD(style: .light)
    
    // container for scrolling in case of small devices, we might not be able to fit everything
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let testField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.systemPink.cgColor
        field.placeholder = "Test Test"
        // to make the text not flush with the box
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
    }()
    
    private let imageView: UIImageView = {
           let imageView = UIImageView()
           imageView.image = UIImage(named: "logo")
           imageView.contentMode = .scaleAspectFit
           return imageView
       }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        
        view.addSubview(scrollView)
        scrollView.addSubview(testField)
        scrollView.addSubview(imageView)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        
        // the view.width comes from the extenstions.swift file
        let size = scrollView.width/3
        // the logo size
        imageView.frame = CGRect(x: (scrollView.width - size)/2,
                                 y: 20,
                                 width: size,
                                 height: size)
        
        // using the standard values for the text boxes and stuff, can change to make look better
        testField.frame = CGRect(x: 30,
                                  y: imageView.bottom+10,
                                  width: scrollView.width - 60,
                                  height: 52)
        
    }
    



}
