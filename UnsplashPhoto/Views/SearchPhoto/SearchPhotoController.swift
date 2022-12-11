import UIKit
import Combine

final class SearchPhotoController: UIViewController {
    
    // MARK: - Private Properties
    private var subscriptions = Set<AnyCancellable>()
    private lazy var searchPhotoView = SearchPhotoView()
    private var photoViewModel: PhotoViewModel!
    
    private var currentPage = 1
    
    // MARK: - Override Methods
    override func loadView() {
        super.loadView()
        
        self.view = searchPhotoView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
        setupBindings()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.delegate = self
        photoViewModel.error = nil
    }
}

// MARK: – Private methods
extension SearchPhotoController {
    
    private func setupView() {
        searchPhotoView.setupCollectionView(
            delegate: self,
            dataSource: self
        )
        searchPhotoView.setupSearchController(for: self)
    }
    
    private func setupViewModel() {
        let tabBar = tabBarController as? TabBarController
        photoViewModel = tabBar?.viewModel
    }
    
    private func setupBindings() {
        photoViewModel.$searchedPhotos
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.searchPhotoView.reloadData()
                }
            }.store(in: &subscriptions)
        
        photoViewModel.$error
            .sink { [weak self] error in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    guard let errorDiscription = error?.localizedDescription else { return }
                    
                    self.present(
                        self.searchPhotoView.getErrorAlert(for: errorDiscription),
                        animated: true
                    )
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
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return photoViewModel.searchedPhotos.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Constants.photoCollectionCellIdentificator,
            for: indexPath
        ) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.setup(for: photoViewModel.searchedPhotos[indexPath.row])
        
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let photoID = photoViewModel.searchedPhotos[indexPath.row].id else { return }
        
        showPhotoDetail(photoID: photoID)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        if indexPath.row == photoViewModel.searchedPhotos.count - 6 {
            currentPage += 1
            photoViewModel.fetchSearchPhotos(
                query: searchPhotoView.getSearchControllerBarText(),
                page: currentPage
            )
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SearchPhotoController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = searchPhotoView.bounds.width
        let numberOfItemsPerRow: CGFloat = 2
        let spacing: CGFloat = searchPhotoView.getFlowLayoutInteritemSpacing()
        let availableWidth = width - spacing * (numberOfItemsPerRow + 1)
        let itemDimension = floor(availableWidth / numberOfItemsPerRow)

        return CGSize(width: itemDimension, height: itemDimension / 1.5)
    }
    
}

// MARK: - UITabBarControllerDelegate
extension SearchPhotoController: UITabBarControllerDelegate {
    
    func tabBarController(
        _ tabBarController: UITabBarController,
        didSelect viewController: UIViewController
    ) {
        searchPhotoView.scrollToTop()
    }
}

// MARK: - UISearchBarDelegate
extension SearchPhotoController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text,
              !searchBarText.isEmpty else { return }
        
        currentPage = 1
        photoViewModel.searchedPhotos = []
        photoViewModel.fetchSearchPhotos(query: searchBarText, page: 1)
        searchPhotoView.reloadData()
        
        searchBar.resignFirstResponder()
    }
}
