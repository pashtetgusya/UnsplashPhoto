//
//  PhotosResult.swift
//  UnsplashPhoto
//
//  Created by Pavel Yarovoi on 31.07.2022.
//

import Foundation

// MARK: - PhotosResult
struct PhotosResult: Codable {
    let total: Int?
    let totalPages: Int?
    let results: [Photo]?

    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
}
