//
//  APODViewController.swift
//  AstronomyPhoto
//
//  Created by Julia Frederico on 02/12/22.
//

import UIKit

class APODViewController: UIViewController {
    
    // MARK: - Properties
    
    var apod: APOD?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var closeLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!

    @IBOutlet weak var imageErrorView: UIView!
    @IBOutlet weak var imageErrorLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        
        layoutViews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        updateViews()
    }
    
    // MARK: - Actions
    
    @IBAction func didPressFavoriteButton(_ sender: UIButton) {
        guard let apod = apod else {
            return
        }
        
        favorite(apod)
    }
    @IBAction func didPressShareButton(_ sender: UIButton) {
        guard let apod = apod else {
            return
        }

        presentActivity(for: apod)
    }

    // MARK: - Helpers
    
    func layoutViews() {
        photoImageView.layer.cornerRadius = 3
    }
    
    func updateViews() {
        guard let apod = apod else {
            return
        }

        dateLabel.text = apod.date.toString()
        titleLabel.text = apod.title
        descriptionLabel.text = apod.description
        
        if let photo = apod.photo {
            photoImageView.image = photo
            hideImageErrorView()
        } else {
            displayImageErrorView()
        }
    }
    
    func configureViews() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        closeLabel.isUserInteractionEnabled = true
        closeLabel.addGestureRecognizer(tap)
    }
    
    @objc func dismissView() {
        self.dismiss(animated: true)
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
    
    func favorite(_ apod: APOD) {
        FavoriteController.shared.favorite(apod: apod) { _ in }
        self.dismissView()
    }

}
