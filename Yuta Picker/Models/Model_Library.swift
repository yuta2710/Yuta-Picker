//
//  Model_LibraryWorkspace.swift
//  Yuta Picker
//
//  Created by Nguyen Phuc Loi on 05/03/2024.
//

import Foundation

struct Library: Codable {
    var id: String
    var name: String
    var colors: [String]
    var ownerId: String
    var createdAt: TimeInterval
    var modifiedAt: TimeInterval
}
