import UIKit
import Kingfisher

// MARK: Photo collection view cell protocol
protocol PhotoCollectionViewCellProtocol: AnyObject {
    
    func setup(for photo: Photo)
}

// MARK: Photo collection view cell
class PhotoCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Public properties
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    // MARK: - Override methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = contentView.bounds
    }
    
    // MARK: - Required methods
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods
extension PhotoCollectionViewCell {
    
    private func setupView() {
        contentView.layer.cornerRadius = 15
        contentView.clipsToBounds = true
        
        contentView.addSubview(imageView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ])
    }
}

// MARK: – PhotoCollectionViewCellProtocol
extension PhotoCollectionViewCell: PhotoCollectionViewCellProtocol {
    
    func setup(for photo: Photo) {
        guard let photoURLString = photo.photoURLs?.regular,
              let photoURL = URL(string: photoURLString) else { return }
        
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: photoURL, options: [
            .cacheOriginalImage
        ])
    }
}
