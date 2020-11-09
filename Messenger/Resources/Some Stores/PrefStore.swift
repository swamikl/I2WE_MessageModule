//
//  PrefStore.swift
//  I2WE
//
//  Created by Jaden Kim on 11/6/20.
//

import Combine

class PrefStore: ObservableObject {
    @Published var pref: [Int:String] = [
        0:"Male",
        1:"Female",
        2:"Other",
        3:"Any"
    ]
}
