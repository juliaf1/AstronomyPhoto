//
//  APODTableViewCell.swift
//  AstronomyPhoto
//
//  Created by Julia Frederico on 02/12/22.
//

import UIKit

class APODTableViewCell: UITableViewCell {

    // MARK: - Properties
    
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
    
    // MARK: - Actions
    
    @IBAction func didPressFavoriteButton(_ sender: UIButton) {
    }
    
    // MARK: - Helpers
    
    func layoutViews() {
        // Round photo top corners
        let path = UIBezierPath(roundedRect: photoImageView.bounds,
                                byRoundingCorners: [.topRight, .topLeft],
                                cornerRadii: CGSize(width: 12, height:  12))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        photoImageView.layer.mask = maskLayer

        // Round card corners + shadow
        cardView.layer.cornerRadius = 12
        cardView.layer.shadowOffset = CGSize(width: 1, height: 1)
        cardView.layer.shadowRadius = 5
        cardView.layer.shadowColor = Colors.black?.cgColor
        cardView.layer.shadowOpacity = 0.3
    }
    
    func updateViews() {
        guard let apod = apod else {
            return
        }

        photoImageView.image = apod.photo
        titleLabel.text = apod.title
        descriptionLabel.text = apod.description
        dateLabel.text = apod.date.toString()
    }
    
}
