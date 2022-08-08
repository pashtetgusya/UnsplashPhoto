//
//  PhotoURLs.swift
//  UnsplashPhoto
//
//  Created by Pavel Yarovoi on 01.08.2022.
//

import Foundation

// MARK: - PhotoURL's
struct PhotoURLs: Codable {
    let raw: String?
    let full: String?
    let regular: String?
    let small: String?
    let thumb: String?
    let smallS3: String?

    enum CodingKeys: String, CodingKey {
        case raw
        case full
        case regular
        case small
        case thumb
        case smallS3 = "small_s3"
    }
}
