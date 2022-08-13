//
//  DetailPhotoView.swift
//  UnsplashPhoto
//
//  Created by Pavel Yarovoi on 29.07.2022.
//

import UIKit
import Kingfisher

class DetailPhotoView: UIView {
    
    // MARK: - Public Properties
    lazy var shareController: UIActivityViewController = {
        let shareController = UIActivityViewController(activityItems: [photoImageView.image as Any], applicationActivities: nil)
        
        return shareController
    }()
    
    lazy var photoInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
        return stackView
    }()
    
    lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        return imageView
    }()
    
    lazy var photoInfoTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(PhotoDetailViewCell.self, forCellReuseIdentifier: Constants.photoDetailCellIdentifier)
        tableView.isHidden = true
        
        return tableView
    }()
    
    lazy var photoToolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.tintColor = .black
        
        return toolbar
    }()
                
    // MARK: - Override Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(photoInfoStackView)
        photoInfoStackView.addArrangedSubview(photoImageView)
        photoInfoStackView.addArrangedSubview(photoInfoTableView)
        
        self.addSubview(photoToolbar)
        
        setupUI()
        setupConstraints()
    }
    
    // MARK: - Required Methods
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        self.backgroundColor = .systemBackground
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
            photoInfoTableView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.30)
        ])
    }
    
    // MARK: - Public Methods
    func setupErrorAlert(error message: String) -> UIAlertController {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "Ok", style: .default)
        
        alert.addAction(actionOK)
        
        return alert
    }
    
}
