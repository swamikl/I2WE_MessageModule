//
//  RegisterViewController.swift
//  Messenger
//
//  Created by Swamik Lamichhane on 10/19/20.
//  Copyright © 2020 Swamik Lamichhane. All rights reserved.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class RegisterViewController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .light)
    
    // container for scrolling in case of small devices, we might not be able to fit everything
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    
    private let firstNameField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.systemPink.cgColor
        field.placeholder = "First Name"
        // to make the text not flush with the box
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
    }()
    
    
    private let lastNameField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.systemPink.cgColor
        field.placeholder = "Last Name"
        // to make the text not flush with the box
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
    }()
    
    
    // the email field for when users might want to register
    // making it look pretty
    private let emailField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.systemPink.cgColor
        field.placeholder = "Email Address"
        // to make the text not flush with the box
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
    }()
    
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done // after writing password, we want to let users into the app
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.systemPink.cgColor
        field.placeholder = "Password"
        // to make the text not flush with the box
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.isSecureTextEntry = true // to get * for password
        return field
    }()
    
    
    
    // for the blank person to show
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle")
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        return imageView
    }()
    
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true // so it cannot overflow
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "log in"
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapRegister))
        
        
        
        // where to go when login button is pressed
        registerButton.addTarget(self,
                                 action: #selector(registerButtonTapped),
                                 for: .touchUpInside)
        // when user hits return on password it calls login function
        emailField.delegate = self
        passwordField.delegate = self
        
        // adding subviews: what is being shown on the screen
        // we are adding elements to the scroll view, so if page fills up, the container will allow for
        // scrollable content
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(firstNameField)
        scrollView.addSubview(lastNameField)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(registerButton)
        
        // to make the image userinteractable
        imageView.isUserInteractionEnabled = true
        scrollView.isUserInteractionEnabled = true
        
        // want to make it so that the user can add a profile picture when the icon is tapped
        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector(didTapChangeProfilePic))
        
        gesture.numberOfTouchesRequired = 1
        gesture.numberOfTapsRequired = 1
        
        imageView.addGestureRecognizer(gesture)
    }
    
    @objc private func didTapChangeProfilePic(){
        presentPhotoActionSheet()
    }
    
    // to give the frame for the image view
    
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
        
        // create the image to look like a circle
        imageView.layer.cornerRadius = imageView.width/2.0
        
        // using the standard values for the text boxes and stuff, can change to make look better
        firstNameField.frame = CGRect(x: 30,
                                      y: imageView.bottom+10,
                                      width: scrollView.width - 60,
                                      height: 52)
        
        lastNameField.frame = CGRect(x: 30,
                                     y: firstNameField.bottom+10,
                                     width: scrollView.width - 60,
                                     height: 52)
        
        emailField.frame = CGRect(x: 30,
                                  y: lastNameField.bottom+10,
                                  width: scrollView.width - 60,
                                  height: 52)
        
        passwordField.frame = CGRect(x: 30,
                                     y: emailField.bottom + 10,
                                     width: scrollView.width - 60,
                                     height: 52)
        
        registerButton.frame = CGRect(x: 30,
                                      y: passwordField.bottom + 10,
                                      width: scrollView.width - 60,
                                      height: 52)
    }
    
    
    // to check if they actually signed in
    // also making sure password is at least 6 char long
    @objc private func registerButtonTapped(){
        
        // getting rid of keyboard after user has entered things
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        firstNameField.resignFirstResponder()
        lastNameField.resignFirstResponder()
        
        guard let firstName = firstNameField.text,
            let lastName = lastNameField.text,
            let email = emailField.text,
            let password = passwordField.text,
            !email.isEmpty,
            !firstName.isEmpty,
            !lastName.isEmpty,
            !password.isEmpty,
            password.count >= 6
            else{
                alertUserRegisterError()
                return
        }
        
        spinner.show(in: view)
        
        // FIREBASE LOGIN STUFF
        
        // first check if a user with that email already is in our database
        DatabaseManager.shared.userExistis(with: email, completion: { [weak self] exists in
            guard let strongSelf = self else {
                return
            }
            
            // all UI stuff needs to be done in the main thread
            DispatchQueue.main.async {
                    strongSelf.spinner.dismiss()
                }
            guard !exists else {
                // this is where the user alredy exists
                strongSelf.alertUserRegisterError(message: "User with that email already exists")
                return
            }
            // creating the user with their given email and password
            FirebaseAuth.Auth.auth().createUser(withEmail: email,
                                                password: password,
                                                completion: { authResult, error in
                                                    
                                                    guard authResult != nil, error == nil else{
                                                        print("Error creating user")
                                                        return
                                                    }
                                                    DatabaseManager.shared.insertUser(with: AppUser(firstName: firstName ,
                                                                                                    lastName: lastName,
                                                                                                    emailAddress: email))
                                                    strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            })
        })
        
    }
    
    func alertUserRegisterError(message: String = "Plese enter all info to create new account"){
        let alert = UIAlertController(title: "OH NO",
                                      message: message,
                                      preferredStyle: .alert)
        
        // allow the user to get rid of alert
        alert.addAction(UIAlertAction(title: "Dismiss",
                                      style: .cancel,
                                      handler: nil))
        
        present(alert, animated: true)
    }
    
    @objc private func didTapRegister(){
        let vc = RegisterViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

// good way to seperate code is to make an extention
// this handels the validation part so the user dosent have to press the login button directly
extension RegisterViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        
        if textField == firstNameField{
            lastNameField.becomeFirstResponder()
        }
        else if textField == lastNameField {
            emailField.becomeFirstResponder()
        }
        else if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            registerButtonTapped()
        }
        return true
    }
}

// for choosing the picture or taking a picture for the profile picture
// when users want to choose a profile pic, they get options on how to choose it

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActionSheet(){
        let actionSheet = UIAlertController(title: "Profile Picture",
                                            message: "Select Picture",
                                            preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        
        actionSheet.addAction(UIAlertAction(title: "Take Photo",
                                            style: .default,
                                            handler: { [weak self] _ in
                                                
                                                self?.presentCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Choose Photo",
                                            style: .default,
                                            handler: { [weak self] _ in
                                                self?.presentPhotoPicker()
        }))
        
        present(actionSheet, animated: true)
    }
    
    func presentCamera(){
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        // allowing the user to crop their profile picture
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func presentPhotoPicker(){
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        // allowing the user to crop their profile picture
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        // to get the information of the pic selected from the info. the edited image is if the person crops the image
        // the as casts it as a UI image
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        
        // updating the image to be the selected image
        self.imageView.image = selectedImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}



