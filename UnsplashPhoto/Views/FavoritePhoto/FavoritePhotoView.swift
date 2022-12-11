import UIKit

// MARK: – Favorite photo view protocol
protocol FavoritePhotoViewProtocol: AnyObject {
    
    func reloadData()
    func scrollToTop()
    func getErrorAlert(for error: String) -> UIAlertController
    func getFlowLayoutInteritemSpacing() -> CGFloat
    func setupCollectionView(delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource)
}

final class FavoritePhotoView: UIView {
    
    // MARK: - Public Properties
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
}
        
// MARK: - Private Methods
extension FavoritePhotoView {
    
    private func setupView() {
        self.backgroundColor = .systemBackground
        
        self.addSubview(photoCollectionView)
        
        photoCollectionView.setCollectionViewLayout(photoCollectionFlowLayout, animated: true)
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

// MARK: – FavoritePhotoViewProtocol
extension FavoritePhotoView: FavoritePhotoViewProtocol {
    
    func reloadData() {
        photoCollectionView.reloadData()
    }
    
    func scrollToTop() {
        photoCollectionView.setContentOffset(.zero, animated: true)
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
    
    func setupCollectionView(
        delegate: UICollectionViewDelegate,
        dataSource: UICollectionViewDataSource
    ) {
        photoCollectionView.delegate = delegate
        photoCollectionView.dataSource = dataSource
    }
}
