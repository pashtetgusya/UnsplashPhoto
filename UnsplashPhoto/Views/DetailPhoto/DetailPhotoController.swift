import UIKit
import Combine

final class DetailPhotoController: UIViewController {
    
    // MARK: - Private Properties
    private var subscriptions = Set<AnyCancellable>()
    private lazy var detailPhotoView = DetailPhotoView()
    private var detailPhotoViewModel: DetailPhotoViewModel!
    
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
        
        detailPhotoViewModel.fetchPhotoDetail(photoID: photoID)
        
        setupView()
    }
    
    // MARK: - Private Methods
    private func setupView() {
        navigationController?.navigationBar.tintColor = .black
        
        detailPhotoView.setupTableView(
            delegate: self,
            dataSource: self
        )
        detailPhotoView.setAddToFavoriteButtonAction(
            #selector(favoritesButtonPressed),
            target: self
        )
        detailPhotoView.setShowPhotoInfoButtonAction(
            #selector(showHidePhotoInfoButtonPressed),
            target: self
        )
        detailPhotoView.setSharePhotoButtonAction(
            #selector(shareButtonPressed),
            target: self
        )
        
        setupToolbarButtons()
    }
    
    private func setupToolbarButtons() {
        detailPhotoView.changePhotoInfoButtonImage()
        detailPhotoView.setAddToFavoriteButtonImage(
            for: FavirotePhotoStorageManager.shared.isFavorite(photoID: photoID)
        )
    }
    
    private func setupViewModel() {
        self.detailPhotoViewModel = DetailPhotoViewModel()
    }
    
    private func setupBindings() {
        detailPhotoViewModel.$photoImageUrl.compactMap { URL(string: $0) }
            .sink { [weak self] imageURL in
                guard let self = self else { return }
                
                self.detailPhotoView.setImage(with: imageURL)
            }
            .store(in: &subscriptions)
        
        detailPhotoViewModel.$error
            .sink { [weak self] error in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    guard let errorDiscription = error?.localizedDescription else { return }
                    
                    self.present(
                        self.detailPhotoView.getErrorAlert(for: errorDiscription),
                        animated: true
                    )
                }
            }.store(in: &subscriptions)
    }
    
    // MARK: - @objc Methods
    @objc func favoritesButtonPressed(_ sender: UIBarButtonItem) {
        if FavirotePhotoStorageManager.shared.isFavorite(photoID: self.photoID) {
            guard let photo = detailPhotoViewModel.getViewModelPhoto() else { return }
            
            FavirotePhotoStorageManager.shared.removePhotoFromFavorites(removed: photo)
            detailPhotoView.setAddToFavoriteButtonImage(for: false)
        } else {
            guard let photo = detailPhotoViewModel.getViewModelPhoto() else { return }
            
            FavirotePhotoStorageManager.shared.addPhotoToFavorites(added: photo)
            detailPhotoView.setAddToFavoriteButtonImage(for: true)
        }
    }
    
    @objc func showHidePhotoInfoButtonPressed(_ sender: UIBarButtonItem) {
        detailPhotoView.showHidePhotoInfoTable()
        detailPhotoView.changePhotoInfoButtonImage()
        detailPhotoView.reloadData()
    }
    
    @objc func shareButtonPressed(_ sender: UIBarButtonItem) {
        present(
            detailPhotoView.getShareController(),
            animated: true
        )
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension DetailPhotoController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(
        in tableView: UITableView
    ) -> Int {
        4
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return 1
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.photoDetailCellIdentifier,
            for: indexPath
        ) as? PhotoDetailViewCell else {
            return UITableViewCell()
        }
        
        switch indexPath.section {
        case 0:
            var user = ""
            Publishers.MergeMany(
                detailPhotoViewModel.$name,
                detailPhotoViewModel.$username
            )
            .sink(receiveValue: { value in
                user += value
            })
            .store(in: &subscriptions)
            
            cell.textLibel.text = user
        case 1:
            detailPhotoViewModel.$photoLocationName
                .assign(to: \.text!, on: cell.textLibel)
                .store(in: &subscriptions)
        case 2:
            detailPhotoViewModel.$photoCreatedDate
                .assign(to: \.text!, on: cell.textLibel)
                .store(in: &subscriptions)
        case 3:
            detailPhotoViewModel.$photoDownloads
                .compactMap { $0.description
                    
                }.assign(to: \.text!, on: cell.textLibel)
                .store(in: &subscriptions)
        default:
            cell.textLibel.text = ""
        }
        
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        titleForHeaderInSection section: Int
    ) -> String? {
        switch section {
        case 0: return "Author"
        case 1: return "Location"
        case 2: return "Published on"
        case 3: return "Downloads"
        default: return nil
        }
    }
}
