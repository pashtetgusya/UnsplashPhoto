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
