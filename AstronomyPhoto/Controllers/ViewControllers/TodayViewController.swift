//
//  TodayViewController.swift
//  AstronomyPhoto
//
//  Created by Julia Frederico on 01/12/22.
//

import UIKit

class TodayViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cardPhoto: UIImageView!
    @IBOutlet weak var cardTitleLabel: UILabel!
    @IBOutlet weak var cardDescriptionLabel: UILabel!
    @IBOutlet weak var cardDateLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
    }
    
    // MARK: - Actions
    
    @IBAction func didPressFavoriteButton(_ sender: UIButton) {
    }
    
    // MARK: Helpers
    
    func updateViews() {
        // Round photo top corners
        let path = UIBezierPath(roundedRect:cardPhoto.bounds,
                                byRoundingCorners:[.topRight, .topLeft],
                                cornerRadii: CGSize(width: 12, height:  12))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        cardPhoto.layer.mask = maskLayer

        // Round card corners + shadow
        cardView.layer.cornerRadius = 12
        cardView.layer.shadowOffset = CGSize(width: 1, height: 1)
        cardView.layer.shadowRadius = 5
        cardView.layer.shadowColor = Colors.black?.cgColor
        cardView.layer.shadowOpacity = 0.3
    }

}
