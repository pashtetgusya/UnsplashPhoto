//
//  StorageManager.swift
//  UnsplashPhoto
//
//  Created by Pavel Yarovoi on 06.08.2022.
//

import Foundation

// MARK: - Favorite photo storage protocol
protocol FavoritePhotoStorageProtocol {

    func loadFavoritePhotos() -> [Photo]
    func saveFavoritePhotos()
    func addPhotoToFavorites(added photo: Photo)
    func removePhotoFromFavorites(removed photo: Photo)
    func isFavorite(photoID: String) -> Bool

}

// MARK: - Favorite photo storage
class FavirotePhotoStorageManager: FavoritePhotoStorageProtocol {
    
    // MARK: - Public Properties
    static let shared = FavirotePhotoStorageManager()
    let storageKey: String = Constants.userDefaultsKey
    
    // MARK: - Private Properties
    private var storage = UserDefaults.standard
    private var favoritePhots = [Photo]() {
        didSet {
            saveFavoritePhotos()
        }
    }
        
    // MARK: - Public Methods
    func loadFavoritePhotos() -> [Photo] {
        if let savedFavoritePhotos = storage.object(forKey: Constants.userDefaultsKey) as? Data {
            let decoder = JSONDecoder()
            if let loadedFavoretiPhotos = try? decoder.decode([Photo].self, from: savedFavoritePhotos) {
                favoritePhots = loadedFavoretiPhotos
            }
        }
        return favoritePhots
    }

    func saveFavoritePhotos() {
        let encoder = JSONEncoder()
        if let encodedObjects = try? encoder.encode(favoritePhots) {
            storage.set(encodedObjects, forKey: Constants.userDefaultsKey)
        }
    }
    
    func addPhotoToFavorites(added photo: Photo) {
        if !favoritePhots.contains(photo) {
            favoritePhots.append(photo)
        }
    }
    
    func removePhotoFromFavorites(removed photo: Photo) {
        if let index = favoritePhots.firstIndex(of: photo) {
            favoritePhots.remove(at: index)
        }
    }
    
    func isFavorite(photoID: String) -> Bool {
        guard !photoID.isEmpty else {
            return false
        }
        return (favoritePhots.filter { $0.id == photoID }.first) != nil
    }
    
}
