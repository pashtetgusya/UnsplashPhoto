//
//  RandomPhotoView.swift
//  UnsplashPhoto
//
//  Created by Pavel Yarovoi on 05.08.2022.
//

import UIKit

class RandomPhotoView: UIView {

    // MARK: - Public Properties
    lazy var photoCollectionFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        
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
    
    lazy var photoCollectionRefreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.attributedTitle = NSAttributedString(string: "Refreshing...")
        
        return refresh
    }()
    
    // MARK: - Override Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupConstraints()
    }
    
    // MARK: - Required Methods
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    // MARK: - Private Methods
    private func setupView() {
        self.backgroundColor = .systemBackground
        
        self.addSubview(photoCollectionView)
        
        photoCollectionView.setCollectionViewLayout(photoCollectionFlowLayout, animated: true)
        photoCollectionView.refreshControl = photoCollectionRefreshControl
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
        
    func endRefreshing() {
        if photoCollectionRefreshControl.isRefreshing {
            photoCollectionRefreshControl.endRefreshing()
        }
    }

}
