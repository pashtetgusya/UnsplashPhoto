//
//  RandomPhotoController.swift
//  UnsplashPhoto
//
//  Created by Pavel Yarovoi on 05.08.2022.
//

import UIKit
import Combine

class RandomPhotoController: UIViewController {
    
    // MARK: - Private Properties
    private var subscriptions = Set<AnyCancellable>()
    private lazy var randomPhotoView = RandomPhotoView()
    private var photoViewModel: PhotoViewModel!

    // MARK: - Override Methods
    override func loadView() {
        super.loadView()
        
        self.view = randomPhotoView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        randomPhotoView.photoCollectionView.delegate = self
        randomPhotoView.photoCollectionView.dataSource = self
        
        setupRefreshControl()
        setupViewModel()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.delegate = self
        photoViewModel.error = nil
        photoViewModel.fetchRandomPhotos()
    }
    
    // MARK: - Private Methods
    private func setupRefreshControl() {
        randomPhotoView.photoCollectionRefreshControl.addTarget(
            self, action: #selector(didPullToRefresh), for: .valueChanged)
    }
    
    private func setupViewModel() {
        let tabBar = tabBarController as? TabBarController
        photoViewModel = tabBar?.viewModel
    }
    
    private func setupBindings() {
        photoViewModel.$randomPhotos
            .sink { [weak self] _ in
                DispatchQueue.main.async {
                    self?.randomPhotoView.photoCollectionView.reloadData()
                    self?.randomPhotoView.endRefreshing()
                }
            }.store(in: &subscriptions)
        
        photoViewModel.$error
            .sink { error in
                DispatchQueue.main.async {
                    guard let errorDiscription = error?.localizedDescription else {
                        return
                    }
                    let aletrController = self.randomPhotoView.setupErrorAlert(error: errorDiscription)
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
    
    // MARK: - @objc Methods
    @objc private func didPullToRefresh() {
        photoViewModel.randomPhotos = []
        photoViewModel.fetchRandomPhotos()
        randomPhotoView.photoCollectionView.reloadData()
    }

}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension RandomPhotoController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoViewModel.randomPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Constants.photoCollectionCellIdentificator,
            for: indexPath
        ) as? PhotoCollectionViewCell {
            cell.setImage(from: photoViewModel.randomPhotos[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.showPhotoDetail(photoID: photoViewModel.randomPhotos[indexPath.row].id ?? "")
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == photoViewModel.randomPhotos.count - 1 {
            photoViewModel.fetchRandomPhotos()
        }
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension RandomPhotoController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = randomPhotoView.photoCollectionView.bounds.width
        let numberOfItemsPerRow: CGFloat = 2
        let spacing: CGFloat = randomPhotoView.photoCollectionFlowLayout.minimumInteritemSpacing
        let availableWidth = width - spacing * (numberOfItemsPerRow + 1)
        let itemDimension = floor(availableWidth / numberOfItemsPerRow)

        return CGSize(width: itemDimension, height: itemDimension / 1.5)
    }
    
}

// MARK: - UITabBarControllerDelegate
extension RandomPhotoController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        randomPhotoView.photoCollectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
}
