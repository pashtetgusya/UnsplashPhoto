//
//  SearchPhotoController.swift
//  UnsplashPhoto
//
//  Created by Pavel Yarovoi on 05.08.2022.
//

import UIKit
import Combine

class SearchPhotoController: UIViewController {

    // MARK: - Private Properties
    private let searchPhotoView = SearchPhotoView()
    private var photoViewModel: PhotoViewModel!
    private var subscriptions = Set<AnyCancellable>()
    private var currentPage = 1

    // MARK: - Override Methods
    override func loadView() {
        super.loadView()
        
        self.view = searchPhotoView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        searchPhotoView.photoCollectionView.delegate = self
        searchPhotoView.photoCollectionView.dataSource = self
        searchPhotoView.photoSearchController.searchBar.delegate = self
        
        searchPhotoView.setupSearchController(in: self)
        
        setupViewModel()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.delegate = self
        photoViewModel.error = nil
    }
    
    // MARK: - Private Methods
    private func setupViewModel() {
        let tabBar = tabBarController as? TabBarController
        photoViewModel = tabBar?.viewModel
    }
    
    private func setupBindings() {
        photoViewModel.$searchedPhotos
            .sink { [weak self] _ in
                DispatchQueue.main.async {
                    self?.searchPhotoView.photoCollectionView.reloadData()
                }
            }.store(in: &subscriptions)
        
        photoViewModel.$error
            .sink { error in
                DispatchQueue.main.async {
                    guard let errorDiscription = error?.localizedDescription else {
                        return
                    }
                    let aletrController = self.searchPhotoView.setupErrorAlert(error: errorDiscription)
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
extension SearchPhotoController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoViewModel.searchedPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Constants.photoCollectionCellIdentificator,
            for: indexPath
        ) as? PhotoCollectionViewCell {
            cell.setImage(from: photoViewModel.searchedPhotos[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showPhotoDetail(photoID: photoViewModel.searchedPhotos[indexPath.row].id ?? "")
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == photoViewModel.searchedPhotos.count - 1 {
            let searchBarText = searchPhotoView.photoSearchController.searchBar.text!
            currentPage += 1
            photoViewModel.fetchSearchPhotos(query: searchBarText, page: currentPage)
        }
    }

}

// MARK: - UICollectionViewDelegateFlowLayout
extension SearchPhotoController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = searchPhotoView.photoCollectionView.bounds.width
        let numberOfItemsPerRow: CGFloat = 2
        let spacing: CGFloat = searchPhotoView.photoCollectionFlowLayout.minimumInteritemSpacing
        let availableWidth = width - spacing * (numberOfItemsPerRow + 1)
        let itemDimension = floor(availableWidth / numberOfItemsPerRow)

        return CGSize(width: itemDimension, height: itemDimension / 1.5)
    }
    
}

// MARK: - UITabBarControllerDelegate
extension SearchPhotoController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        searchPhotoView.photoCollectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
}

// MARK: - UISearchBarDelegate
extension SearchPhotoController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text else {
            return
        }
        
        if !searchBarText.isEmpty {
            currentPage = 1
            photoViewModel.searchedPhotos = []
            photoViewModel.fetchSearchPhotos(query: searchBarText, page: 1)
            searchPhotoView.photoCollectionView.reloadData()
        }
        searchBar.resignFirstResponder()
    }

}
