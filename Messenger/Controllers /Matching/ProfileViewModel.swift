//
//  ChatModels.swift
//  Messenger
//
//  Created by Swamik Lamichhane on 11/17/20.
//  Copyright © 2020 Swamik Lamichhane. All rights reserved.
//

import Foundation

enum ProfileViewModelType {
    case info, logout
}

struct ProfileViewModel {
    let viewModelType: ProfileViewModelType
    let title: String
    let handler: (() -> Void)?
}
