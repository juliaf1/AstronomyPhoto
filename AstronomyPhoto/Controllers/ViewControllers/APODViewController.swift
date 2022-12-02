//
//  APODViewController.swift
//  AstronomyPhoto
//
//  Created by Julia Frederico on 02/12/22.
//

import UIKit

class APODViewController: UIViewController {
    
    // MARK: - Properties
    
    var apod: APOD? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var closeLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
    }
    
    // MARK: - Actions
    
    @IBAction func didPressFavoriteButton(_ sender: UIButton) {
    }
    @IBAction func didPressShareButton(_ sender: UIButton) {
    }

    // MARK: - Helpers
    
    func updateViews() {
        guard let apod = apod else {
            return
        }

        dateLabel.text = apod.date.toString()
        photoImageView.image = apod.photo
        titleLabel.text = apod.title
        descriptionLabel.text = apod.description
    }
    
    func configureViews() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        closeLabel.isUserInteractionEnabled = true
        closeLabel.addGestureRecognizer(tap)
    }
    
    @objc func dismissView() {
        self.dismiss(animated: true)
    }

}
