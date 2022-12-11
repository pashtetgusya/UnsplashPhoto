import Foundation

// MARK: - Favorite photo storage protocol
protocol FavoritePhotoStorageProtocol: AnyObject {

    func loadFavoritePhotos() -> [Photo]?
    func saveFavoritePhotos()
    func addPhotoToFavorites(added photo: Photo)
    func removePhotoFromFavorites(removed photo: Photo)
    func isFavorite(photoID: String) -> Bool
}

// MARK: - Favorite photo storage
final class FavirotePhotoStorageManager {
    
    // MARK: - Public Properties
    static let shared = FavirotePhotoStorageManager()
    
    // MARK: - Private Properties
    private let storageKey: String = Constants.userDefaultsKey
    private var storage = UserDefaults.standard
    private var favoritePhots = [Photo]() {
        didSet {
            saveFavoritePhotos()
        }
    }
}
        
// MARK: – FavoritePhotoStorageProtocol
extension FavirotePhotoStorageManager: FavoritePhotoStorageProtocol {
    
    func loadFavoritePhotos() -> [Photo]? {
        guard let savedFavoritePhotos = storage.object(forKey: storageKey) as? Data,
              let loadedFavoretiPhotos = try? JSONDecoder().decode([Photo].self, from: savedFavoritePhotos) else {
            return nil
        }
        
        favoritePhots = loadedFavoretiPhotos
        
        return favoritePhots
    }

    func saveFavoritePhotos() {
        let encoder = JSONEncoder()
        guard let encodedObjects = try? encoder.encode(self.favoritePhots) else { return }
        
        storage.set(encodedObjects, forKey: storageKey)
    }
    
    func addPhotoToFavorites(added photo: Photo) {
        if !favoritePhots.contains(photo) {
            favoritePhots.append(photo)
        }
    }
    
    func removePhotoFromFavorites(removed photo: Photo) {
        guard let index = favoritePhots.firstIndex(of: photo) else { return }
        
        favoritePhots.remove(at: index)
    }
    
    func isFavorite(photoID: String) -> Bool {
        guard !photoID.isEmpty,
              (favoritePhots.filter { $0.id == photoID }.first) != nil else {
            return false
        }
        
        return true
    }
}
