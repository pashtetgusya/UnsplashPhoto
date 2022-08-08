//
//  NetworkManager.swift
//  UnsplashPhoto
//
//  Created by Pavel Yarovoi on 29.07.2022.
//

import Foundation
import Alamofire

class NetworkManager {
    
    // MARK: - Public Properties
    static let shared = NetworkManager()

    // MARK: - Initial Methods
    private init() {}
    
    // MARK: - Public Methods
    func fetchData<T: Codable>(path: String, query: String? = nil, page: Int? = nil, type: T.Type, completionHandler: @escaping (Result<T, AFError>) -> Void) {
        guard let token = ProcessInfo.processInfo.environment["UNSPLASH_CLIENT_ID"] else {
            return
        }

        let url = createURL(path: path)
        let queryParameters = prepareParameters(token: token, query: query, page: page)
        
        AF.request(url, parameters: queryParameters)
            .validate()
            .responseDecodable(of: type) { responce in
                completionHandler(responce.result)
            }
    }
    
    // MARK: - Private Methods
    private func createURL(path: String) -> URL {
        var components = URLComponents()
        components.scheme = Constants.scheme
        components.host = Constants.host
        components.path = path
        
        return components.url!
    }
    
    private func prepareParameters(token: String, query: String? = nil, page: Int? = nil) -> [String: String] {
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
