//
//  Constants.swift
//  UnsplashPhoto
//
//  Created by Pavel Yarovoi on 01.08.2022.
//

import Foundation

struct Constants {
    static let scheme = "https"
    static let host = "api.unsplash.com"
    static let randomPhotosPath = "/photos/random/"
    static let searchPhotosPath = "/search/photos"
    static let photoDetailsPath = "/photos/"
    
    static let photosOnPage = 10
    static let photoCollectionCellIdentificator = "PhotoCell"
    static let photoDetailCellIdentifier = "PhotoDetailCell"
    static let userDefaultsKey = "FavoritePhotos"
}
