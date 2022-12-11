import UIKit

// MARK: Random photo view protocol
protocol RandomPhotoViewProtocol: AnyObject {
    
    func reloadData()
    func scrollToTop()
    func endRefreshing()
    func getErrorAlert(for error: String) -> UIAlertController
    func getFlowLayoutInteritemSpacing() -> CGFloat
    func setupRefreshControl(for controller: UIViewController, action: Selector)
    func setupCollectionView(delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource)
}

// MARK: – Random photo view
final class RandomPhotoView: UIView {
    
    // MARK: - Private view elements
    private lazy var photoCollectionFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(
            top: 0,
            left: 5,
            bottom: 0,
            right: 5
        )
        
        return layout
    }()
    
    private lazy var photoCollectionView: UICollectionView = {
        let collection = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewLayout()
        )
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.clipsToBounds = true
        collection.register(
            PhotoCollectionViewCell.self,
            forCellWithReuseIdentifier: Constants.photoCollectionCellIdentificator
        )
        
        return collection
    }()
    
    private lazy var photoCollectionRefreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.attributedTitle = NSAttributedString(string: "Refreshing...")
        
        return refresh
    }()
    
    // MARK: - Override methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupConstraints()
    }
    
    // MARK: - Required methods
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods
extension RandomPhotoView {
    
    // MARK: – Setup methods
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
    
}

// MARK: – RandomPhotoViewProtocol
extension RandomPhotoView: RandomPhotoViewProtocol {
    
    func reloadData() {
        photoCollectionView.reloadData()
    }
    
    func scrollToTop() {
        photoCollectionView.setContentOffset(.zero, animated: true)
    }
    
    func endRefreshing() {
        if photoCollectionRefreshControl.isRefreshing {
            photoCollectionRefreshControl.endRefreshing()
        }
    }
    
    func getErrorAlert(for error: String) -> UIAlertController {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "Ok", style: .default)
        
        alert.addAction(actionOK)
        
        return alert
    }
    
    func getFlowLayoutInteritemSpacing() -> CGFloat {
        return photoCollectionFlowLayout.minimumInteritemSpacing
    }
    
    func setupRefreshControl(
        for controller: UIViewController,
        action: Selector
    ) {
        photoCollectionRefreshControl.addTarget(
            controller,
            action: action,
            for: .valueChanged
        )
    }
    
    func setupCollectionView(
        delegate: UICollectionViewDelegate,
        dataSource: UICollectionViewDataSource
    ) {
        photoCollectionView.delegate = delegate
        photoCollectionView.dataSource = dataSource
    }
}
