////
////  ProfileViewController.swift
////  Messenger
////
////  Created by Swamik Lamichhane on 10/19/20.
////  Copyright © 2020 Swamik Lamichhane. All rights reserved.
//// Followed a tutorial for a IOS messenging app to learn how to use swift and building an IOS app
//// https://www.youtube.com/playlist?list=PL5PR3UyfTWvdlk-Qi-dPtJmjTj-2YIMMf
//
//import UIKit
//import FirebaseAuth
//import FBSDKLoginKit
//import GoogleSignIn
//
//class ProfileViewController: UIViewController {
//
//
//    // this is outlet from the storyboard not from code
//    @IBOutlet var tableView: UITableView!
//
//    let data = ["Log Out"]
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        tableView.register(UITableViewCell.self,
//                           forCellReuseIdentifier: "cell")
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.tableHeaderView = createTableHeader()
//
//        // Do any additional setup after loading the view.
//    }
//
//    func createTableHeader() -> UIView?{
//        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
//            return nil
//        }
//
//        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
//        // this is how the profile picture is getting saved to the database
//        let filename = safeEmail + "_profile_picture.png"
//
//        // path to getting the profile picture
//        let path = "images/"+filename
//        let headerView = UIView(frame: CGRect(x: 0,
//                                              y: 0,
//                                              width: self.view.width,
//                                              height: 300))
//        headerView.backgroundColor = .link
//
//        let imageView = UIImageView(frame: CGRect(x: (headerView.width-150)/2,
//                                                  y: 75,
//                                                  width: 150,
//                                                  height: 150))
//
//
//        imageView.contentMode = .scaleAspectFill
//        imageView.layer.borderColor = UIColor.white.cgColor
//        imageView.layer.borderWidth = 3
//        imageView.backgroundColor = .white
//        imageView.layer.masksToBounds = true
//        imageView.layer.cornerRadius = imageView.width/2
//        headerView.addSubview(imageView)
//
//        // getting the image url to get the image url
//        StorageManager.shared.downloadURL(for: path, completion: { [weak self] result in
//            switch result {
//            case .success(let url):
//                self?.downloadImage(imageView: imageView, url: url)
//            case .failure(let error):
//                print("Failed to get download url: \(error)")
//            }
//        })
//
//        return headerView
//    }
//
//    // download the image based on the url
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
//
//}
//
//
//
//
////Mark database stuff no need look
//extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return data.count
//    }
//
//    // log out button
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel?.text = data[indexPath.row]
//        cell.textLabel?.textAlignment = .center
//        cell.textLabel?.textColor = .red
//        return cell
//    }
//
//    // function that is presenting things in the profile page
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//
//        let actionSheet = UIAlertController(title: "",
//                                            message: "",
//                                            preferredStyle: .actionSheet)
//
//        actionSheet.addAction(UIAlertAction(title: "Log Out",
//                                            style: .destructive,
//                                            handler: { [weak self]_ in
//                                                guard let strongSelf = self else {
//                                                    return
//                                                }
//
//                                                // log out facebook
//                                                FBSDKLoginKit.LoginManager().logOut()
//
//                                                // log out google
//                                                GIDSignIn.sharedInstance()?.signOut()
//
//
//                                                do{
//                                                    try FirebaseAuth.Auth.auth().signOut()
//                                                    let vc = LoginViewController()
//                                                    let nav = UINavigationController(rootViewController: vc)
//                                                    nav.modalPresentationStyle = .fullScreen
//                                                    strongSelf.present(nav, animated: true)
//                                                }
//                                                catch{
//                                                    print("failed to log out")
//                                                }
//        }))
//
//        actionSheet.addAction(UIAlertAction(title: "Cancel",
//                                            style: .cancel,
//                                            handler: nil))
//
//        present(actionSheet, animated: true)
//
//    }
//}
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn
import SDWebImage

final class ProfileViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    var data = [ProfileViewModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ProfileTableViewCell.self,
                           forCellReuseIdentifier: ProfileTableViewCell.identifier)

        data.append(ProfileViewModel(viewModelType: .info,
                                     title: "Name: \(UserDefaults.standard.value(forKey:"name") as? String ?? "No Name")",
                                     handler: nil))
        data.append(ProfileViewModel(viewModelType: .info,
                                     title: "Email: \(UserDefaults.standard.value(forKey:"email") as? String ?? "No Email")",
                                     handler: nil))
        data.append(ProfileViewModel(viewModelType: .logout, title: "Log Out", handler: { [weak self] in

            guard let strongSelf = self else {
                return
            }

            let actionSheet = UIAlertController(title: "",
                                          message: "",
                                          preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Log Out",
                                          style: .destructive,
                                          handler: { [weak self] _ in

                                            guard let strongSelf = self else {
                                                return
                                            }

                                            UserDefaults.standard.setValue(nil, forKey: "email")
                                            UserDefaults.standard.setValue(nil, forKey: "name")

                                            // Log Out facebook
                                            FBSDKLoginKit.LoginManager().logOut()

                                            // Google Log out
                                            GIDSignIn.sharedInstance()?.signOut()

                                            do {
                                                try FirebaseAuth.Auth.auth().signOut()

                                                let vc = LoginViewController()
                                                let nav = UINavigationController(rootViewController: vc)
                                                nav.modalPresentationStyle = .fullScreen
                                                strongSelf.present(nav, animated: true)
                                            }
                                            catch {
                                                print("Failed to log out")
                                            }

            }))

            actionSheet.addAction(UIAlertAction(title: "Cancel",
                                                style: .cancel,
                                                handler: nil))

            strongSelf.present(actionSheet, animated: true)
        }))

        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = createTableHeader()
    }

    func createTableHeader() -> UIView? {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return nil
        }

        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        let filename = safeEmail + "_profile_picture.png"
        let path = "images/"+filename

        let headerView = UIView(frame: CGRect(x: 0,
                                        y: 0,
                                        width: self.view.width,
                                        height: 300))

        headerView.backgroundColor = .link

        let imageView = UIImageView(frame: CGRect(x: (headerView.width-150) / 2,
                                                  y: 75,
                                                  width: 150,
                                                  height: 150))
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 3
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.width/2
        headerView.addSubview(imageView)

        StorageManager.shared.downloadURL(for: path, completion: { result in
            switch result {
            case .success(let url):
                imageView.sd_setImage(with: url, completed: nil)
            case .failure(let error):
                print("Failed to get download url: \(error)")
            }
        })

        return headerView
    }

}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier,
                                                 for: indexPath) as! ProfileTableViewCell
        cell.setUp(with: viewModel)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        data[indexPath.row].handler?()
    }
}

class ProfileTableViewCell: UITableViewCell {

    static let identifier = "ProfileTableViewCell"

    public func setUp(with viewModel: ProfileViewModel) {
        self.textLabel?.text = viewModel.title
        switch viewModel.viewModelType {
        case .info:
            textLabel?.textAlignment = .left
            selectionStyle = .none
        case .logout:
            textLabel?.textColor = .red
            textLabel?.textAlignment = .center
        }
    }

}
