//
//  APODTableViewCell.swift
//  AstronomyPhoto
//
//  Created by Julia Frederico on 02/12/22.
//

import UIKit

protocol APODTableViewCellDelegate {
    func toggleFavorite(for cell: APODTableViewCell)
}

class APODTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    var delegate: APODTableViewCellDelegate?
    
    var apod: APOD? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutViews()
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!

    @IBOutlet weak var imageErrorView: UIView!
    @IBOutlet weak var imageErrorLabel: UILabel!

    // MARK: - Actions
    
    @IBAction func didPressFavoriteButton(_ sender: UIButton) {
        delegate?.toggleFavorite(for: self)
    }
    
    // MARK: - Helpers
    
    func layoutViews() {
        photoImageView.roundCorners(radius: 12)

        cardView.layer.cornerRadius = 12
        cardView.lightShadow()
    }
    
    func updateViews() {
        guard let apod = apod else {
            return
        }

        titleLabel.text = apod.title
        descriptionLabel.text = apod.description
        dateLabel.text = apod.date.toString()
        
        if let photo = apod.photo {
            photoImageView.image = photo
            hideImageErrorView()
        } else {
            displayImageErrorView()
        }
    }
    
    func hideImageErrorView() {
        imageErrorView.isHidden = true
        imageErrorLabel.isHidden = true
    }
    
    func displayImageErrorView() {
        photoImageView.image = UIImage(named: Strings.defaultPhotoName)
        imageErrorView.isHidden = false
        imageErrorLabel.isHidden = false
    }
    
}
