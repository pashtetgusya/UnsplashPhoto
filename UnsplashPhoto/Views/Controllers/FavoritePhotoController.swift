//
//  FavoritePhotoController.swift
//  UnsplashPhoto
//
//  Created by Pavel Yarovoi on 05.08.2022.
//

import UIKit
import Combine

class FavoritePhotoController: UIViewController {

    // MARK: - Private Properties
    private var subscriptions = Set<AnyCancellable>()
    private lazy var favoritePhotoView = FavoritePhotoView()
    private var photoViewModel: PhotoViewModel!

    // MARK: - Override Methods
    override func loadView() {
        super.loadView()
        
        self.view = favoritePhotoView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        favoritePhotoView.photoCollectionView.delegate = self
        favoritePhotoView.photoCollectionView.dataSource = self
        
        setupViewModel()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.delegate = self
        photoViewModel.error = nil
        photoViewModel.fetchFavoritePhotos()
    }
    
    // MARK: - Private Methods
    private func setupViewModel() {
        let tabBar = tabBarController as? TabBarController
        photoViewModel = tabBar?.viewModel
    }
    
    private func setupBindings() {
        photoViewModel.$favoritePhots
            .sink { [weak self] _ in
                DispatchQueue.main.async {
                    self?.favoritePhotoView.photoCollectionView.reloadData()
                }
            }.store(in: &subscriptions)
        
        photoViewModel.$error
            .sink { error in
                DispatchQueue.main.async {
                    guard let errorDiscription = error?.localizedDescription else {
                        return
                    }
                    let aletrController = self.favoritePhotoView.setupErrorAlert(error: errorDiscription)
                    self.present(aletrController, animated: true)
                }
            }.store(in: &subscriptions)
    }
    
    // MARK: - Navigation
    private func showPhotoDetail(photoID: String) {
        let viewController = DetailPhotoController()
        viewController.photoID = photoID
        viewController.hidesBottomBarWhenPushed = true
        viewController.modalPresentationStyle = .fullScreen
            
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension FavoritePhotoController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoViewModel.favoritePhots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Constants.photoCollectionCellIdentificator,
            for: indexPath
        ) as? PhotoCollectionViewCell {
            cell.setImage(from: photoViewModel.favoritePhots[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.showPhotoDetail(photoID: photoViewModel.favoritePhots[indexPath.row].id ?? "")
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FavoritePhotoController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = favoritePhotoView.photoCollectionView.bounds.width
        let numberOfItemsPerRow: CGFloat = 2
        let spacing: CGFloat = favoritePhotoView.photoCollectionFlowLayout.minimumInteritemSpacing
        let availableWidth = width - spacing * (numberOfItemsPerRow + 1)
        let itemDimension = floor(availableWidth / numberOfItemsPerRow)

        return CGSize(width: itemDimension, height: itemDimension / 1.5)
    }
    
}

// MARK: - UITabBarControllerDelegate
extension FavoritePhotoController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        favoritePhotoView.photoCollectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
}
