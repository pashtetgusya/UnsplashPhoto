import Foundation
import Combine
import Alamofire

// MARK: - Photo view model protocol
protocol PhotoViewModelProtocol: AnyObject {
     
    func fetchRandomPhotos()
    func fetchSearchPhotos(query: String, page: Int)
    func fetchFavoritePhotos()
}

// MARK: - Photo view model
final class PhotoViewModel: ObservableObject {
    
    // MARK: - Output
    @Published var error: AFError?
    
    @Published var currentPhoto: Photo?
    @Published var randomPhotos = [Photo]()
    @Published var searchText: String? = String()
    @Published var searchedPhotos = [Photo]()
    @Published var favoritePhots = [Photo]()
}

// MARK: – PhotoViewModelProtocol
extension PhotoViewModel: PhotoViewModelProtocol {
    
    func fetchRandomPhotos() {
        NetworkManager.shared.fetchData(
            path: Constants.randomPhotosPath,
            type: [Photo].self
        ) { [weak self] responce in
            guard let self = self else { return }
            
            switch responce {
            case .success(let data):
                self.randomPhotos += data
            case .failure(let error):
                self.error = error
            }
        }
    }
    
    func fetchSearchPhotos(query: String, page: Int) {
        NetworkManager.shared.fetchData(
            path: Constants.searchPhotosPath,
            query: query,
            page: page,
            type: PhotosResult.self
        ) { [weak self] responce in
            guard let self = self else { return }
            
            switch responce {
            case .success(let data):
                self.searchedPhotos += data.results!
            case .failure(let error):
                self.error = error
            }
        }
    }
    
    func fetchFavoritePhotos() {
        guard let photos = FavirotePhotoStorageManager.shared.loadFavoritePhotos() else { return }
        
        favoritePhots = photos
    }
}
