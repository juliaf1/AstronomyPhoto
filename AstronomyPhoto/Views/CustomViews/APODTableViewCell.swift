//
//  APODTableViewCell.swift
//  AstronomyPhoto
//
//  Created by Julia Frederico on 02/12/22.
//

import UIKit

protocol APODTableViewCellDelegate {
    func toggleFavorite(_ apod: APOD)
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
        guard let apod = apod else {
            return
        }
        
        delegate?.toggleFavorite(apod)
    }
    
    // MARK: - Helpers
    
    func layoutViews() {
        photoImageView.roundCorners(radius: 12)

        cardView.layer.cornerRadius = 12
        cardView.lightShadow()
        
        guard let apod = apod else {
            return
        }
        
        if apod.favorite {
            favoriteButton.setImage(nil, for: .normal)
            favoriteButton.setTitle("Remove", for: .normal)
        } else {
            favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            favoriteButton.setTitle("", for: .normal)
        }
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
