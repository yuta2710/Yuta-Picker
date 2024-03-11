//
//  Model_Account.swift
//  Yuta Picker
//
//  Created by Nguyen Phuc Loi on 05/03/2024.
//

import Foundation

enum AccountError: Error, CaseIterable {
    case invalidEmail
    case invalidName
}

struct Account: Codable {
    var id: String 
    var email: String
    var name: String
    var paletteIds: [String]
    var libraryWorkspaceIds: [String]
}
