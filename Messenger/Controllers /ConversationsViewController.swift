//
//  ViewController.swift
//  Messenger
//
//  Created by Swamik Lamichhane on 10/19/20.
//  Copyright © 2020 Swamik Lamichhane. All rights reserved.
// Followed a tutorial for a IOS messenging app to learn how to use swift and building an IOS app
// https://www.youtube.com/playlist?list=PL5PR3UyfTWvdlk-Qi-dPtJmjTj-2YIMMf

// main file that gets instantiated
//import UIKit


import UIKit
import FirebaseAuth
import JGProgressHUD


struct Conversation {
    let id: String
    let name: String
    let otherUserEmail: String
    let latestMessage: LatestMessage
}

struct LatestMessage {
    let date: String
    let text: String
    let isRead: Bool
}

class ConversationsViewController: UIViewController {
    
    private var conversations = [Conversation]()
    
    private let spinner = JGProgressHUD(style: .light)
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.isHidden = true
         table.register(ConversationTableViewCell.self,
                               forCellReuseIdentifier: ConversationTableViewCell.identifier)
        return table
    }()
    
    private let noConversationsLabel: UILabel = {
        let label = UILabel()
        label.text = "No Conversations!"
        label.textAlignment = .center
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 21, weight: .medium)
        label.isHidden = true
        return label
    }()
    
    // there is a problem with the chat not showing up immideatly so this is so that we can view the chat immedietly
    private var loginObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose,
                                                            target: self,
                                                            action: #selector(didTapComposeButton))
        view.addSubview(tableView)
        view.addSubview(noConversationsLabel)
        setupTableView()
        // fetchConversations()
        startListeningForConversations()
        
        loginObserver = NotificationCenter.default.addObserver(forName: .didLogInNotification, object: nil, queue: .main, using: { [weak self] _ in
                   guard let strongSelf = self else {
                       return
                   }

                   strongSelf.startListeningForConversations()
            })
    }
    
    private func startListeningForConversations() {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        print("starting conversation fetch...")

        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)

        DatabaseManager.shared.getAllConversations(for: safeEmail, completion: { [weak self] result in
            switch result {
            case .success(let conversations):
                print("got the conversations")
                guard !conversations.isEmpty else {
                    self?.tableView.isHidden = true
                    self?.noConversationsLabel.isHidden = false
                    return
                }
                
                self?.noConversationsLabel.isHidden = true
                self?.tableView.isHidden = false
                self?.conversations = conversations

                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                self?.tableView.isHidden = true
                self?.noConversationsLabel.isHidden = false
                print("did not get the conversations: \(error)")
            }
        })
    }
    
    @objc private func didTapComposeButton() {
        let vc = NewConversationViewController()
        vc.completion = { [weak self] result in
            guard let strongSelf = self else {
                return
            }

            let currentConversations = strongSelf.conversations

            if let targetConversation = currentConversations.first(where: {
                $0.otherUserEmail == DatabaseManager.safeEmail(emailAddress: result.email)
            }) {
                let vc = ChatViewController(with: targetConversation.otherUserEmail, id: targetConversation.id)
                vc.isNewConversation = false
                vc.title = targetConversation.name
                vc.navigationItem.largeTitleDisplayMode = .never
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            }
            else {
                strongSelf.createNewConversation(result: result)
            }
        }
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
        
    }
    
   private func createNewConversation(result: SearchResult) {
    let name = result.name
    let email = result.email
       
    // we are first going to check if a convo with these 2 users already exists
    // if it does, we are just adding to it
    // if it does not, create a new one
        DatabaseManager.shared.conversationExists(iwth: email, completion: { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success(let conversationId):
                let vc = ChatViewController(with: email, id: conversationId)
                vc.isNewConversation = false
                vc.title = name
                vc.navigationItem.largeTitleDisplayMode = .never
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            case .failure(_):
                let vc = ChatViewController(with: email, id: nil)
                vc.isNewConversation = true
                vc.title = name
                vc.navigationItem.largeTitleDisplayMode = .never
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            }
        })
               
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        noConversationsLabel.frame = CGRect(x: 10,
        y: (view.height-100)/2,
        width: view.width-20,
        height: 100)
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateAuth()
        
    }
    
    // if the current user is nill we want to show the log in screen
    // if user has already signed in, we dont want to show it so this is going to check
    // currentUser is handeled by firebase
    private func validateAuth() {
        if FirebaseAuth.Auth.auth().currentUser == nil {
                 let vc = LoginViewController()
                 let nav = UINavigationController(rootViewController: vc)
                 nav.modalPresentationStyle = .fullScreen
                 present(nav, animated: true)
             }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    
}

extension ConversationsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = conversations[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ConversationTableViewCell.identifier,
                                                 for: indexPath) as! ConversationTableViewCell
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       tableView.deselectRow(at: indexPath, animated: true)
        let model = conversations[indexPath.row]
        openConversation(model)
        
    }
    
    // doing it like this to make this more module so that we ccan call this function over and over again
    func openConversation(_ model: Conversation) {
        let vc = ChatViewController(with: model.otherUserEmail, id: model.id)
        vc.title = model.name
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    // to delete a convo
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                // begin delete
                let conversationId = conversations[indexPath.row].id
                tableView.beginUpdates()

                DatabaseManager.shared.deleteConversation(conversationId: conversationId, completion: { [weak self] success in
                    if success {
                        self?.conversations.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .left)
                    }
                })

                tableView.endUpdates()
            }
        }
    }
