//
//  PhotoDetailViewCell.swift
//  UnsplashPhoto
//
//  Created by Pavel Yarovoi on 08.08.2022.
//

import UIKit

class PhotoDetailViewCell: UITableViewCell {
    
    // MARK: - Public Properties
    lazy var textLibel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        
        return label
    }()

    // MARK: - Override Methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
        setupConstraints()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
    // MARK: - Required Methods
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func setupView() {
        contentView.clipsToBounds = true
        
        contentView.addSubview(textLibel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            textLibel.topAnchor.constraint(equalTo: contentView.topAnchor),
            textLibel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            textLibel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            textLibel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

}
