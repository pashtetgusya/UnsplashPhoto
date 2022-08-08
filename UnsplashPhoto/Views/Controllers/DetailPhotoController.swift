//
//  DetailPhotoController.swift
//  UnsplashPhoto
//
//  Created by Pavel Yarovoi on 29.07.2022.
//

import UIKit
import Combine

class DetailPhotoController: UIViewController {
    
    // MARK: - Private Properties
    private var subscriptions = Set<AnyCancellable>()
    private let detailPhotoView = DetailPhotoView()
    private var detailPhotoViewModel: DetailPhotoViewModel!
    
    private let favoriteButton = UIBarButtonItem(image: UIImage(systemName: "heart.fil"), style: .done, target: self, action: #selector(favoritesButtonPressed))
    private let photoInfoButton = UIBarButtonItem(image: UIImage(systemName: "info.circle.fill"), style: .done, target: self, action: #selector(showHidePhotoInfoButtonPressed))
    private let shareButton = UIBarButtonItem(image: UIImage(systemName: "arrowshape.turn.up.right"), style: .done, target: self, action: #selector(shareButtonPressed))
    private let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    
    // MARK: - Public Properties
    var photoID: String!
    
    // MARK: - Override Methods
    override func loadView() {
        super.loadView()
        
        self.view = detailPhotoView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
        setupBindings()
        setupView()
        
        detailPhotoViewModel.fetchPhotoDetail(photoID: photoID)
    }
    
    // MARK: - Private Methods
    private func setupView() {
        self.navigationController?.navigationBar.tintColor = .black
        
        detailPhotoView.photoInfoTableView.dataSource = self
        detailPhotoView.photoInfoTableView.delegate = self
        
        setupToolbarButtons()
        detailPhotoView.photoToolbar.items = [favoriteButton, spacer, photoInfoButton, spacer, shareButton]
    }
        
    private func setupToolbarButtons() {
        let favoriteButtonImage = FavirotePhotoStorageManager.shared.isFavorite(photoID: photoID) ? "heart.fill" : "heart"
        favoriteButton.image = UIImage(systemName: favoriteButtonImage)
        let photoInfoButtonImage = detailPhotoView.photoInfoTableView.isHidden ? "info.circle" : "info.circle.fill"
        photoInfoButton.image = UIImage(systemName: photoInfoButtonImage)
    }
    
    private func setupViewModel() {
        self.detailPhotoViewModel = DetailPhotoViewModel()
    }
    
    private func setupBindings() {
        detailPhotoViewModel.$photoImageUrl.compactMap { URL(string: $0) }
            .sink { [weak self] imageURL in
                self?.detailPhotoView.photoImageView.kf.setImage(with: imageURL)
            }
            .store(in: &subscriptions)
        
        detailPhotoViewModel.$error
            .sink { error in
                DispatchQueue.main.async {
                    guard let errorDiscription = error?.localizedDescription else {
                        return
                    }
                    let aletrController = self.detailPhotoView.setupErrorAlert(error: errorDiscription)
                    self.present(aletrController, animated: true)
                }
            }.store(in: &subscriptions)
    }
    
    // MARK: - @objc Methods
    @objc func favoritesButtonPressed(_ sender: UIBarButtonItem) {
        if FavirotePhotoStorageManager.shared.isFavorite(photoID: self.photoID) {
            FavirotePhotoStorageManager.shared.removePhotoFromFavorites(removed: detailPhotoViewModel.photo!)
        } else {
            FavirotePhotoStorageManager.shared.addPhotoToFavorites(added: detailPhotoViewModel.photo!)
        }
        setupToolbarButtons()
    }
    
    @objc func showHidePhotoInfoButtonPressed(_ sender: UIBarButtonItem) {
        detailPhotoView.photoInfoTableView.isHidden = detailPhotoView.photoInfoTableView.isHidden ? false : true
        setupToolbarButtons()
    }
    
    @objc func shareButtonPressed(_ sender: UIBarButtonItem) {
        present(detailPhotoView.shareController, animated: true)
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension DetailPhotoController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        5
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 0 : 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.photoDetailCellIdentifier, for: indexPath) as? PhotoDetailViewCell {
            var cellText = ""
            
            switch indexPath.section {
            case 1: cellText = "\(detailPhotoViewModel.name) (@\(detailPhotoViewModel.username))"
            case 2: cellText = "\(detailPhotoViewModel.photoLocationName)"
            case 3: cellText = "\(detailPhotoViewModel.photoCreatedDate)"
            case 4: cellText = "\(detailPhotoViewModel.photoDownloads)"
            default: cellText = ""
            }
            
            if #available(iOS 14.0, *) {
                var cellConfiguration = cell.defaultContentConfiguration()
                cellConfiguration.text = cellText
                cell.contentConfiguration = cellConfiguration
            } else {
                cell.textLabel?.text = cellText
            }
            
            return cell
        } else {
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return nil
        case 1: return "Author"
        case 2: return "Location"
        case 3: return "Published on"
        case 4: return "Downloads"
        default: return nil
        }
    }

}
