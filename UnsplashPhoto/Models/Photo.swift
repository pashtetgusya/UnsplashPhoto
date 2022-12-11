import Foundation

// MARK: - Photo
struct Photo: Codable {
    
    let id: String?
    let created: String?
    let description: String?
    let downloads: Int?
    let photoURLs: PhotoURLs?
    let user: User?
    let location: PhotoLocation?

    enum CodingKeys: String, CodingKey {
        case id
        case created = "created_at"
        case description
        case downloads
        case photoURLs = "urls"
        case user
        case location
    }
}

// MARK: - Equatable
extension Photo: Equatable {
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        lhs.id == rhs.id
    }
}
