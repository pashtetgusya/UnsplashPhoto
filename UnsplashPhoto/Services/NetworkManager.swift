import Foundation
import Alamofire

// MARK: – Network manager
final class NetworkManager {
    
    // MARK: - Public properties
    static let shared = NetworkManager()
    
    // MARK: - Initial methods
    private init() { }
    
    // MARK: - Public methods
    func fetchData<T: Codable>(
        path: String,
        query: String? = nil,
        page: Int? = nil,
        type: T.Type,
        completionHandler: @escaping (Result<T, AFError>) -> Void
    ) {
        guard let token = Bundle.main.object(forInfoDictionaryKey: "UNSPLASH_CLIENT_ID") as? String else { return }
        
        let url = createURL(path: path)
        let queryParameters = prepareParameters(token: token, query: query, page: page)
        
        AF.request(url, parameters: queryParameters)
            .validate()
            .responseDecodable(of: type) { responce in
                completionHandler(responce.result)
            }
    }
}

// MARK: - Private methods
extension NetworkManager {
    
    private func createURL(path: String) -> URL {
        var components = URLComponents()
        components.scheme = Constants.scheme
        components.host = Constants.host
        components.path = path
        
        return components.url!
    }
    
    private func prepareParameters(
        token: String,
        query: String? = nil,
        page: Int? = nil
    ) -> [String: String] {
        var parameters = [String: String]()
        
        parameters["client_id"] = token
        parameters["count"] = String(Constants.photosOnPage)
        
        if let query = query {
            parameters["query"] = query
        }
        
        if let page = page {
            parameters["page"] = page.description
        }
        
        return parameters
    }
}
