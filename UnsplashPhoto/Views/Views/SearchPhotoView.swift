//
//  SearchPhotoView.swift
//  UnsplashPhoto
//
//  Created by Pavel Yarovoi on 07.08.2022.
//

import UIKit

class SearchPhotoView: UIView {

    // MARK: - Public Properties
    lazy var photoCollectionFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        return layout
    }()

    lazy var photoCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.clipsToBounds = true
        collection.register(
            PhotoCollectionViewCell.self,
            forCellWithReuseIdentifier: Constants.photoCollectionCellIdentificator
        )
        
        return collection
    }()
        
    let photoSearchController: UISearchController = {
        let search = UISearchController()
        search.searchBar.placeholder = "Search photo..."
        
        return search
    }()
    
    // MARK: - Override Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(photoCollectionView)

        setupUI()
        setupConstraints()
    }
    
    // MARK: - Required Methods
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    // MARK: - Private Methods
    private func setupUI() {
        photoCollectionView.setCollectionViewLayout(photoCollectionFlowLayout, animated: true)
        
        self.backgroundColor = .systemBackground
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            photoCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            photoCollectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            photoCollectionView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
            photoCollectionView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor)
        ])
    }
        
    // MARK: - Public Methods
    func setupErrorAlert(error message: String) -> UIAlertController {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "Ok", style: .default)
        
        alert.addAction(actionOK)
        
        return alert
    }
    
    func setupSearchController(in controller: UIViewController) {
        controller.navigationItem.searchController = self.photoSearchController
    }

}
