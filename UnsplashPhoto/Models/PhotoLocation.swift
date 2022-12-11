import Foundation
    
// MARK: - PhotoLocation
struct PhotoLocation: Codable {
    
    let title: String?
    let name: String?
    let country: String?
    let position: PhotoLocationPosition?
}
