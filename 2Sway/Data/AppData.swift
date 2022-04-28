//
//  AppData.swift
//  2Sway
//
//  Created by Abhishek Dubey on 22/01/22.
//

import Foundation

class AppData {
    static var shared = AppData()
    var business: [Business] = []
    var user: UserModel?
    var ver : LatestVersion?
}
