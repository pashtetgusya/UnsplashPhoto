import UIKit
import Combine

final class RandomPhotoController: UIViewController {
    
    // MARK: - Private properties
    private lazy var randomPhotoView = RandomPhotoView()
    private var photoViewModel: PhotoViewModel!
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Override methods
    override func loadView() {
        super.loadView()
        
        self.view = randomPhotoView
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

// MARK: - Private methods
extension RandomPhotoController {
    
    // MARK: – Setup methods
    private func setupView() {
        randomPhotoView.setupRefreshControl(
            for: self,
            action: #selector(didPullToRefresh)
        )
        randomPhotoView.setupCollectionView(
            delegate: self,
            dataSource: self
        )
        photoViewModel.fetchRandomPhotos()
    }
    
    private func setupViewModel() {
        let tabBar = tabBarController as? TabBarController
        photoViewModel = tabBar?.viewModel
    }
    
    private func setupBindings() {
        photoViewModel.$randomPhotos
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.randomPhotoView.reloadData()
                    self.randomPhotoView.endRefreshing()
                }
            }.store(in: &subscriptions)
        
        photoViewModel.$error
            .sink { [weak self] error in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    guard let errorDiscription = error?.localizedDescription else { return }
                    
                    self.present(
                        self.randomPhotoView.getErrorAlert(for: errorDiscription),
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
    
    // MARK: - @objc methods
    @objc private func didPullToRefresh() {
        photoViewModel.randomPhotos.removeAll()
        photoViewModel.fetchRandomPhotos()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension RandomPhotoController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return photoViewModel.randomPhotos.count
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
        
        cell.setup(for: photoViewModel.randomPhotos[indexPath.row])
        
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let photoID = photoViewModel.randomPhotos[indexPath.row].id else { return }
        
        showPhotoDetail(photoID: photoID)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        if indexPath.row == photoViewModel.randomPhotos.count - 4 {
            photoViewModel.fetchRandomPhotos()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension RandomPhotoController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = randomPhotoView.bounds.width
        let numberOfItemsPerRow: CGFloat = 2
        let spacing: CGFloat = randomPhotoView.getFlowLayoutInteritemSpacing()
        let availableWidth = width - spacing * (numberOfItemsPerRow + 1)
        let itemDimension = floor(availableWidth / numberOfItemsPerRow)
        
        return CGSize(width: itemDimension, height: itemDimension / 1.5)
    }
}

// MARK: - UITabBarControllerDelegate
extension RandomPhotoController: UITabBarControllerDelegate {
    
    func tabBarController(
        _ tabBarController: UITabBarController,
        didSelect viewController: UIViewController
    ) {
        randomPhotoView.scrollToTop()
    }
}
