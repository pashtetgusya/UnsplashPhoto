//
//  PhotoLocation.swift
//  UnsplashPhoto
//
//  Created by Pavel Yarovoi on 06.08.2022.
//

import Foundation
    
// MARK: - PhotoLocation
struct PhotoLocation: Codable {
    let title: String?
    let name: String?
    let country: String?
    let position: PhotoLocationPosition?
    }
