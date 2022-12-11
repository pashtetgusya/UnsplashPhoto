import Foundation
import Combine
import Alamofire

// MARK: - Detail photo view model protocol
protocol DetailPhotoViewModelProtocol: AnyObject {
    
    func fetchPhotoDetail(photoID: String)
    func getViewModelPhoto() -> Photo?
}

// MARK: - Detail photo view model
final class DetailPhotoViewModel {
    
    // MARK: - Output
    @Published private(set) var error: AFError?
    
    @Published private(set) var name = ""
    @Published private(set) var username = ""
    
    @Published private(set) var photoCreatedDate = ""
    @Published private(set) var photoLocationName = ""
    @Published private(set) var photoDownloads = 0
    @Published private(set) var photoImageUrl: String = ""
    
    // MARK: - Private properties
    private var photo: Photo? {
        didSet {
            configureOutput()
        }
    }
}

// MARK: - Private methods
extension DetailPhotoViewModel {
    
    private func configureOutput() {
        name = photo?.user?.name ?? ""
        username = " @\(photo?.user?.username ?? "")"
        photoCreatedDate = changeDateFormat(string: photo?.created ?? "")
        photoImageUrl = photo?.photoURLs?.regular ?? ""
        photoDownloads = photo?.downloads ?? 0
        photoLocationName = photo?.location?.title ?? ""
    }
    
    private func changeDateFormat(string: String) -> String {
        guard !string.isEmpty else {
            return ""
        }
        
        var formattedDate = ""
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        guard let date = formatter.date(from: string) else {
            return ""
        }
            
        formatter.dateFormat = "MMM d, yyyy"
        formattedDate = formatter.string(from: date)
        
        return formattedDate
    }
}

// MARK: – DetailPhotoViewModelProtocol
extension DetailPhotoViewModel: DetailPhotoViewModelProtocol {
    
    func fetchPhotoDetail(photoID: String) {
        let path = Constants.photoDetailsPath + photoID
        
        NetworkManager.shared.fetchData(
            path: path,
            type: Photo.self
        ) { [weak self] responce in
            guard let self = self else { return }
            
            switch responce {
            case .success(let data):
                self.photo = data
            case .failure(let error):
                self.error = error
            }
        }
    }
    
    func getViewModelPhoto() -> Photo? {
        guard let photo = photo else {
            return nil
        }
        
        return photo
    }
}
