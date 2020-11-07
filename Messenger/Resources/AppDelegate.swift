//
//  AppDelegate.swift
//  Messenger
//
//  Created by Swamik Lamichhane on 10/19/20.
//  Copyright © 2020 Swamik Lamichhane. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate{
    
    
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        FirebaseApp.configure()
        
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.delegate = self
        
        return true
    }
    
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        
        // for the FB sign in
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
        
        // the google sign in
        return GIDSignIn.sharedInstance().handle(url)
        
    }
    
    // for the google sign in
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard error == nil else {
            if let error = error {
                print("Failed to sign in with google")
            }
                        return
        }
        guard let user = user else {
            return
        }
        print ("Did sign in with Google: \(user)")

        
        guard let email = user.profile.email,
            let firstName = user.profile.givenName,
            let lastName = user.profile.familyName else {
                return
        }
        
        
        DatabaseManager.shared.userExistis(with: email, completion: { exists in
            if !exists{
                DatabaseManager.shared.insertUser(with: AppUser(firstName: firstName,
                    lastName: lastName,
                    emailAddress: email))
            }
        })
        
        
        guard let authentication = user.authentication else {
            print("missing auth obj from google user")
            return
            
        }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        FirebaseAuth.Auth.auth().signIn(with: credential, completion: { authResult, error in
            guard authResult != nil, error == nil else {
                print("Failed to login with google credential")
                return
            }
            print("signed in with google")
            // fire the notification to dismiss
            NotificationCenter.default.post(name: .didLogInNotification, object: nil)
        })
    }
    
    // Perform any operations when the user disconnects from app here.
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("Google user disconnected")
    }
    
    
}

