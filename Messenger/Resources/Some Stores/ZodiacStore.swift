//
//  ZodiacStore.swift
//  I2WE
//
//  Created by Jaden Kim on 11/2/20.
//

import Combine

class ZodiacStore: ObservableObject {
    @Published var zodiac: [Int:String] = [
        0:"♒️",
        1:"♓️",
        2:"♈️",
        3:"♉️",
        4:"♊️",
        5:"♋️",
        6:"♌️",
        7:"♍️",
        8:"♎️",
        9:"♏️",
        10:"♐️",
        11:"♑️"
    ]
}
