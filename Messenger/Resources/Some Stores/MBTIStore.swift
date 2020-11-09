//
//  MBTIStore.swift
//  I2WE
//
//  Created by Jaden Kim on 11/2/20.
//

import Combine

class MBTIStore: ObservableObject {
    @Published var mbti: [Int:String] = [
        0: "ISTJ",
        1: "ISFJ",
        2: "INFJ",
        3: "INTJ",
        4: "ISTP",
        5: "ISFP",
        6: "INFP",
        7: "INTP",
        8: "ESTP",
        9: "ESFP",
        10: "ENFP",
        11: "ENTP",
        12: "ESTJ",
        13: "ESFJ",
        14: "ENFJ",
        15: "ENTJ"
    ]
}
