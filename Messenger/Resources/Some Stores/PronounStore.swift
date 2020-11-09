//
//  PronounStore.swift
//  I2WE
//
//  Created by Jaden Kim on 11/2/20.
//

import Combine

class PronounStore: ObservableObject {
    @Published var pronouns: [Int:String] = [
        0:"He/Him",
        1:"She/Her",
        2:"They/Them"
    ]
}
