import UIKit
import Combine

final class FavoritePhotoController: UIViewController {
    
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
        
        setupViewModel()
        setupBindings()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.delegate = self
        photoViewModel.error = nil
        photoViewModel.fetchFavoritePhotos()
    }
}

// MARK: - Private Methods
extension FavoritePhotoController {
    
    private func setupView() {
        favoritePhotoView.setupCollectionView(
            delegate: self,
            dataSource: self
        )
    }
    
    private func setupViewModel() {
        let tabBar = tabBarController as? TabBarController
        photoViewModel = tabBar?.viewModel
    }
    
    private func setupBindings() {
        photoViewModel.$favoritePhots
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.favoritePhotoView.reloadData()
                }
            }.store(in: &subscriptions)
        
        photoViewModel.$error
            .sink { [weak self] error in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    guard let errorDiscription = error?.localizedDescription else { return }
                    
                    self.present(
                        self.favoritePhotoView.getErrorAlert(for: errorDiscription),
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
extension FavoritePhotoController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return photoViewModel.favoritePhots.count
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
        
        cell.setup(for: photoViewModel.favoritePhots[indexPath.row])
        
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let photoID = photoViewModel.favoritePhots[indexPath.row].id else { return }
        
        showPhotoDetail(photoID: photoID)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FavoritePhotoController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = favoritePhotoView.bounds.width
        let numberOfItemsPerRow: CGFloat = 2
        let spacing: CGFloat = favoritePhotoView.getFlowLayoutInteritemSpacing()
        let availableWidth = width - spacing * (numberOfItemsPerRow + 1)
        let itemDimension = floor(availableWidth / numberOfItemsPerRow)

        return CGSize(width: itemDimension, height: itemDimension / 1.5)
    }
}

// MARK: - UITabBarControllerDelegate
extension FavoritePhotoController: UITabBarControllerDelegate {
    
    func tabBarController(
        _ tabBarController: UITabBarController,
        didSelect viewController: UIViewController
    ) {
        favoritePhotoView.scrollToTop()
    }
}
