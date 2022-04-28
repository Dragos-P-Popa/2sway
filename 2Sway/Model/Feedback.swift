//
//  Feedback.swift
//  2Sway
//
//  Created by Abhishek Dubey on 19/01/22.
//

import Foundation

struct Feedback {
    var username: String
    var description: String
    var timeStamp: Date
    
    enum CodingKeys: String, CodingKey {
        case username
        case description
        case timeStamp
    }
}

extension Feedback: Encodable {
    func encode(to encoder: Encoder) throws {
        var feedback = encoder.container(keyedBy: CodingKeys.self)
        try feedback.encode(username, forKey: .username)
        try feedback.encode(description, forKey: .description)
        try feedback.encode(timeStamp, forKey: .timeStamp)
    }
}
