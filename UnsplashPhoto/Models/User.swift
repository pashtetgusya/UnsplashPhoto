//
//  User.swift
//  UnsplashPhoto
//
//  Created by Pavel Yarovoi on 01.08.2022.
//

import Foundation

// MARK: - User
struct User: Codable {
    let id: String?
    let username: String?
    let name: String?
    let profileImage: UserProfileImage?

    enum CodingKeys: String, CodingKey {
        case id
        case username
        case name
        case profileImage = "profile_image"
    }
}
