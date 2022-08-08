//
//  PhotoDetailViewCell.swift
//  UnsplashPhoto
//
//  Created by Pavel Yarovoi on 08.08.2022.
//

import UIKit

class PhotoDetailViewCell: UITableViewCell {
  
    // MARK: - Private Properties
    private let textLibel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    // MARK: - Override Methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.clipsToBounds = true
        contentView.addSubview(textLibel)
        
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
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            textLibel.topAnchor.constraint(equalTo: contentView.topAnchor),
            textLibel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textLibel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textLibel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

}
