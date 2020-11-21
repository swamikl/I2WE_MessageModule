//
//  LoginViewController.swift
//  Messenger
//
//  Created by Swamik Lamichhane on 10/19/20.
//  Copyright © 2020 Swamik Lamichhane. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn
import JGProgressHUD

class LoginViewController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .light)
    
    // container for scrolling in case of small devices, we might not be able to fit everything
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
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
    
    
    
    // for the logo to show
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = .systemPink
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true // so it cannot overflow
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    private let facebookButton: FBLoginButton = {
        let button = FBLoginButton()
        button.permissions = ["email, public_profile"]
        return button
    }()
    
    private let googleLogInButton = GIDSignInButton()
    
    private var loginObserver: NSObjectProtocol?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // we are going to send a notificatoin from the app delegate and listen in here for the purpose of login
        loginObserver = NotificationCenter.default.addObserver(forName: .didLogInNotification, object: nil, queue: .main,
                                                               using: { [weak self] _ in
                                                                guard let strongSelf = self else {
                                                                    return
                                                                }
                                                                strongSelf.navigationController?.dismiss(animated: true,
                                                                                                         completion: nil)
        })
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        
        view.backgroundColor = .white
        title = "log in"
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapRegister))
        
        
        
        // where to go when login button is pressed
        loginButton.addTarget(self,
                              action: #selector(loginButtonTapped),
                              for: .touchUpInside)
        // when user hits return on password it calls login function
        emailField.delegate = self
        passwordField.delegate = self
        
        // facebookButton.delegate = self
        
        
        
        
        // adding subviews: what is being shown on the screen
        // we are adding elements to the scroll view, so if page fills up, the container will allow for
        // scrollable content
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(loginButton)
        // scrollView.addSubview(facebookButton)
        // scrollView.addSubview(googleLogInButton)
    }
    
    // if we hear the notification, we want to deinitialize for memory sake
    deinit {
        if let observer = loginObserver {
            NotificationCenter.default.removeObserver(loginObserver)
        }
    }
    
    
    // to give the frame for the image view
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        scrollView.contentSize = CGSize(width: 375, height: 800)
        
        // the view.width comes from the extenstions.swift file
        let size = scrollView.width/3
        // the logo size
        imageView.frame = CGRect(x: (scrollView.width - size)/2,
                                 y: 20,
                                 width: size,
                                 height: size)
        
        // using the standard values for the text boxes and stuff, can change to make look better
        emailField.frame = CGRect(x: 30,
                                  y: imageView.bottom+10,
                                  width: scrollView.width - 60,
                                  height: 52)
        
        passwordField.frame = CGRect(x: 30,
                                     y: emailField.bottom + 10,
                                     width: scrollView.width - 60,
                                     height: 52)
        
        loginButton.frame = CGRect(x: 30,
                                   y: passwordField.bottom + 10,
                                   width: scrollView.width - 60,
                                   height: 52)
        
//        facebookButton.frame = CGRect(x: 30,
//                                      y: loginButton.bottom + 10,
//                                      width: scrollView.width - 60,
//                                      height: 52)
//
//        googleLogInButton.frame = CGRect(x: 30,
//                                         y: facebookButton.bottom + 10,
//                                         width: scrollView.width - 60,
//                                         height: 52)
    }
    
    
    // to check if they actually signed in
    // also making sure password is at least 6 char long
    @objc private func loginButtonTapped(){
        
        // getting rid of keyboard after user has entered things
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        
        guard let email = emailField.text, let password = passwordField.text,
            !email.isEmpty, !password.isEmpty, password.count >= 6
            else{
                alertUserLoginError()
                return
        }
        
        spinner.show(in: view)
        
        // This is where we add the Firebase Log in
        // this is the authentication using email not google email
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] authResult, error in
            
            guard let strongSelf = self else{
                return
            }
            
            // all UI stuff needs to be done in the main thread
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss()
            }
            
            
            guard let result = authResult, error == nil else{
                print ("fail to log in user with email: \(email)")
                return
            }
            
            let user = result.user
            
            // saving the user email address and name
            
            let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
            DatabaseManager.shared.getDataFor(path: safeEmail, completion: { result in
                switch result {
                case .success(let data):
                    guard let userData = data as? [String: Any],
                        let firstName = userData["first_name"] as? String,
                        let lastName = userData["last_name"] as? String else {
                            return
                    }
                    UserDefaults.standard.set("\(firstName) \(lastName)", forKey: "name")

                case .failure(let error):
                    print("Failed to read data with error \(error)")
                }
            })

            UserDefaults.standard.set(email, forKey: "email")
            
            
            print("logged in with user: \(user)")
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
        })
    }
    
    func alertUserLoginError(){
        let alert = UIAlertController(title: "OH NO",
                                      message: "Please enter all information to login",
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
extension LoginViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        
        if textField == emailField{
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            loginButtonTapped()
        }
        
        return true
    }
    
}

// if the user signs in through FB, we need to get that data and put that into our firebase database
// This extention is handeling that
//extension LoginViewController: LoginButtonDelegate{
//    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
//        // no operation
//    }
//
//    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
//        guard let token = result?.token?.tokenString else {
//            print ("User could not login with FB")
//            return
//        }
        
//        // to handel the FB login
//        // we need to grab data from FB
//
//        let facebookRequest = FBSDKLoginKit.GraphRequest(graphPath: "me",
//                                                         parameters: ["fields": "email, first_name, last_name, picture.type(large)"],
//                                                         tokenString: token,
//                                                         version: nil,
//                                                         httpMethod: .get)
//
//        facebookRequest.start(completionHandler: {_, result, error in
//            guard let result = result as? [String: Any], error == nil else {
//                print ("Failed FB graph request")
//                return
//            }
//
//            print(result)
//            // We need to get the email and name fromt the FB graph request
//            guard let firstName = result["first_name"] as? String,
//                let lastName = result["last_name"] as? String,
//                let email = result["email"] as? String,
//                let picture = result["picture"] as? [String: Any],
//                let data = picture["data"] as? [String: Any],
//                let pictureUrl = data["url"] as? String else{
//                    print ("cant get info from FB graph")
//                    return
//            }
//
//            let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
//
//            // saving the user email address and name
//            UserDefaults.standard.set(email, forKey: "email")
//            UserDefaults.standard.set("\(firstName) \(lastName)", forKey: "name")
//
//
//            // checking if user exists, if they do sign in if not add to database
//            DatabaseManager.shared.userExistis(with: safeEmail, completion: {exists in
//                if !exists {
//                    let appUser = AppUser(firstName: firstName,
//                                          lastName: lastName,
//                                          emailAddress: email,
//                                        uid: "",
//                                        age: )
//                    DatabaseManager.shared.insertUser(with: appUser, completion: { success in
//                        if success {
//                            // getting the pic from FB
//                            guard let url = URL(string: pictureUrl) else {
//                                return
//                            }
//                            URLSession.shared.dataTask(with: url, completionHandler: { data, _, _ in
//                                guard let data = data else {
//                                    print("failed to get data from facebook")
//                                    return
//                                }
//
//                                // upload image
//                                let fileName = appUser.profilePictureFileName
//                                StorageManager.shared.uploadProfilePicture(with: data, fileName: fileName, completion: { result in
//                                    switch result {
//                                    case .success(let downloadUrl):
//                                        UserDefaults.standard.set(downloadUrl, forKey: "profile_picture_url")
//                                        print(downloadUrl)
//                                    case .failure(let error):
//                                        print("storage manager error: \(error)")
//                                    }
//
//                                })
//                            }).resume()
//
//                        }
//
//                    })
//                }
//            })
//
//            // using the token from FB to exchange for firebase auth
//            let credential = FacebookAuthProvider.credential(withAccessToken: token)
//            FirebaseAuth.Auth.auth().signIn(with: credential, completion: { [weak self] authResult, error in
//
//                guard let strongSelf = self else {
//                    return
//                }
//                guard authResult != nil, error == nil else {
//                    if let error = error {
//                        print ("Could not login with FB - \(error)")
//                    }
//                    return
//                }
//
//                print ("User logged in with FB")
//                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
//            })
//        })
//
//
//    }
    
//}
