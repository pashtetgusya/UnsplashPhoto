//
//  PhotoViewModel.swift
//  UnsplashPhoto
//
//  Created by Pavel Yarovoi on 01.08.2022.
//

import Foundation
import Combine
import Alamofire

class PhotoViewModel {

    // MARK: - Output
    @Published var error: AFError?
    
    @Published var currentPhoto: Photo?
    @Published var randomPhotos = [Photo]()
    @Published var searchedPhotos = [Photo]()
    @Published var favoritePhots = [Photo]()
    
    // MARK: - Fetch data
    func fetchRandomPhotos() {
        NetworkManager.shared.fetchData(path: Constants.randomPhotosPath, type: [Photo].self) { responce in
            switch responce {
            case .success(let data):
                self.randomPhotos += data
            case .failure(let error):
                self.error = error
            }
        }
    }
    
    func fetchSearchPhotos(query: String, page: Int) {
        NetworkManager.shared.fetchData(path: Constants.searchPhotosPath, query: query, page: page, type: PhotosResult.self) { responce in
            switch responce {
            case .success(let data):
                self.searchedPhotos += data.results!
            case .failure(let error):
                self.error = error
            }
        }
    }
    
    func fetchFavoritePhotos() {
        self.favoritePhots = FavirotePhotoStorageManager.shared.loadFavoritePhotos()
    }
    
}
