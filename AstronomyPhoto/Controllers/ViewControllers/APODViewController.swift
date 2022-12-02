//
//  APODViewController.swift
//  AstronomyPhoto
//
//  Created by Julia Frederico on 02/12/22.
//

import UIKit

class APODViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    // MARK: - Outlets
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    
    @IBAction func didPressFavoriteButton(_ sender: UIButton) {
    }
    @IBAction func didPressShareButton(_ sender: UIButton) {
    }

    // MARK: - Helpers

}
