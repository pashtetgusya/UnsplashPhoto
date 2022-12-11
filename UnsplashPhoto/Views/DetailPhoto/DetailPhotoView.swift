import UIKit
import Kingfisher

protocol DetailPhotoViewProtocol: AnyObject {
    
    func reloadData()
    func getErrorAlert(for error: String) -> UIAlertController
    func getShareController() -> UIActivityViewController
    func setupTableView(delegate: UITableViewDelegate, dataSource: UITableViewDataSource)
    func setAddToFavoriteButtonAction(_ action: Selector, target: UIViewController)
    func setShowPhotoInfoButtonAction(_ action: Selector, target: UIViewController)
    func setSharePhotoButtonAction(_ action: Selector, target: UIViewController)
    func setAddToFavoriteButtonImage(for status: Bool)
    func changePhotoInfoButtonImage()
    func setImage(with imageURL: URL)
    func showHidePhotoInfoTable()
}

final class DetailPhotoView: UIView {
    
    // MARK: - Private Properties
    private lazy var shareController: UIActivityViewController = {
        let shareController = UIActivityViewController(
            activityItems: [photoImageView.image as Any],
            applicationActivities: nil
        )
        
        return shareController
    }()
    
    private lazy var photoInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
        return stackView
    }()
    
    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(
            .defaultHigh,
            for: .vertical
        )
        
        return imageView
    }()
    
    private lazy var photoInfoTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(
            PhotoDetailViewCell.self,
            forCellReuseIdentifier: Constants.photoDetailCellIdentifier
        )
        tableView.isHidden = true
        tableView.allowsSelection = false
        tableView.alwaysBounceVertical = false
        
        return tableView
    }()
    
    private lazy var photoToolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.tintColor = .black
        
        return toolbar
    }()
    
    private lazy var addToFavoriteButton: UIBarButtonItem = {
        let item = UIBarButtonItem(
            image: UIImage(systemName: "heart.fil"),
            style: .plain,
            target: self,
            action: nil
        )
        
        return item
    }()
    
    private lazy var showPhotoInfoButton: UIBarButtonItem = {
        let item = UIBarButtonItem(
            image: UIImage(systemName: "info.circle.fill"),
            style: .plain,
            target: self,
            action: nil
        )
        
        return item
    }()
    
    private lazy var sharePhotoButton: UIBarButtonItem = {
        let item = UIBarButtonItem(
            image: UIImage(systemName: "arrowshape.turn.up.right"),
            style: .plain,
            target: self,
            action: nil
        )
        
        return item
    }()
    
    private lazy var spacer: UIBarButtonItem = {
        let item = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        
        return item
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
extension DetailPhotoView {
    
    private func setupView() {
        self.backgroundColor = .systemBackground
        
        self.addSubview(photoInfoStackView)
        self.addSubview(photoToolbar)
        photoInfoStackView.addArrangedSubview(photoImageView)
        photoInfoStackView.addArrangedSubview(photoInfoTableView)
        
        photoToolbar.setItems(
            [
                addToFavoriteButton,
                spacer,
                showPhotoInfoButton,
                spacer,
                sharePhotoButton
            ],
            animated: true
        )
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            photoInfoStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            photoInfoStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            photoInfoStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            photoInfoStackView.bottomAnchor.constraint(equalTo: photoToolbar.topAnchor),
            
            photoToolbar.topAnchor.constraint(equalTo: photoInfoStackView.bottomAnchor),
            photoToolbar.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            photoToolbar.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            photoToolbar.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            photoToolbar.heightAnchor.constraint(equalToConstant: 45),
            
            photoImageView.topAnchor.constraint(equalTo: photoInfoStackView.topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: photoInfoStackView.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: photoInfoStackView.trailingAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: photoInfoTableView.topAnchor),
            
            photoInfoTableView.topAnchor.constraint(equalTo: photoImageView.bottomAnchor),
            photoInfoTableView.leadingAnchor.constraint(equalTo: photoInfoStackView.leadingAnchor),
            photoInfoTableView.trailingAnchor.constraint(equalTo: photoInfoStackView.trailingAnchor),
            photoInfoTableView.bottomAnchor.constraint(equalTo: photoInfoStackView.bottomAnchor),
            photoInfoTableView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.4)
        ])
    }
}

extension DetailPhotoView: DetailPhotoViewProtocol {
    
    func reloadData() {
        photoInfoTableView.reloadData()
    }
    
    func getErrorAlert(for error: String) -> UIAlertController {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "Ok", style: .default)
        
        alert.addAction(actionOK)
        
        return alert
    }
    
    func getShareController() -> UIActivityViewController {
        return shareController
    }
    
    func setupTableView(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
        photoInfoTableView.delegate = delegate
        photoInfoTableView.dataSource = dataSource
    }
    
    func setAddToFavoriteButtonAction(_ action: Selector, target: UIViewController) {
        addToFavoriteButton.target = target
        addToFavoriteButton.action = action
    }
    
    func setShowPhotoInfoButtonAction(_ action: Selector, target: UIViewController) {
        showPhotoInfoButton.target = target
        showPhotoInfoButton.action = action
    }
    
    func setSharePhotoButtonAction(_ action: Selector, target: UIViewController) {
        sharePhotoButton.target = target
        sharePhotoButton.action = action
    }
    
    func setAddToFavoriteButtonImage(for status: Bool) {
        let buttomImageName = status ? "heart.fill" : "heart"
        addToFavoriteButton.image = UIImage(systemName: buttomImageName)
    }
    
    func changePhotoInfoButtonImage() {
        let buttonImageName = photoInfoTableView.isHidden
        ? "info.circle"
        : "info.circle.fill"
        
        showPhotoInfoButton.image = UIImage(systemName: buttonImageName)
    }
    
    func setImage(with imageURL: URL) {
        photoImageView.kf.setImage(with: imageURL)
    }
    
    func showHidePhotoInfoTable() {
        UIView.animate(withDuration: 0.3, delay: 0) { [weak self] in
            guard let self = self else { return }
            
            self.photoInfoTableView.isHidden.toggle()
        }
    }
}
