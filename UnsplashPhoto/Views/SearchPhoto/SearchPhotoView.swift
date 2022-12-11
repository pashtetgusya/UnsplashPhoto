import UIKit

// MARK: Search photo view protocol
protocol SearchPhotoViewProtocol: AnyObject {
    
    func reloadData()
    func scrollToTop()
    func getErrorAlert(for error: String) -> UIAlertController
    func getSearchControllerBarText() -> String
    func getFlowLayoutInteritemSpacing() -> CGFloat
    func setupCollectionView(delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource)
    func setupSearchController(for controller: UIViewController)
}

// MARK: – Search photo view
final class SearchPhotoView: UIView {
    
    // MARK: - Private view elements
    private lazy var photoCollectionFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(
            top: 5,
            left: 5,
            bottom: 5,
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
    
    private lazy var photoSearchController: UISearchController = {
        let search = UISearchController()
        search.searchBar.placeholder = "Search photo..."
        
        return search
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
extension SearchPhotoView {
    
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

// MARK: – SearchPhotoViewProtocol
extension SearchPhotoView: SearchPhotoViewProtocol {
    
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
    
    func getSearchControllerBarText() -> String {
        guard let text = photoSearchController.searchBar.text else {
            return ""
        }
        
        return text
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
    
    func setupSearchController(for controller: UIViewController) {
        controller.navigationItem.searchController = photoSearchController
        photoSearchController.searchBar.delegate = controller as? UISearchBarDelegate
    }
}
