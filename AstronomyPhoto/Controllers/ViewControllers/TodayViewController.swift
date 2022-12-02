//
//  TodayViewController.swift
//  AstronomyPhoto
//
//  Created by Julia Frederico on 01/12/22.
//

import UIKit

class TodayViewController: UIViewController {
    
    // MARK: - Property
    
    let loadingVC = LoadingViewController()
    
    var apod: APOD? {
        return APODController.shared.today
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cardPhotoImageView: UIImageView!
    @IBOutlet weak var cardTitleLabel: UILabel!
    @IBOutlet weak var cardDescriptionLabel: UILabel!
    @IBOutlet weak var cardDateLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!

    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()

        layoutViews()
        hideViews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if apod == nil {
            presentLoading(loadingVC)
            loadData()
        } else {
            displayViews()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        hideViews()
    }
    
    // MARK: - Actions
    
    @IBAction func didPressFavoriteButton(_ sender: UIButton) {
    }
    
    // MARK: Helpers
    
    func layoutViews() {
        cardPhotoImageView.roundCorners(radius: 12)

        cardView.layer.cornerRadius = 12
        cardView.lightShadow()
    }
    
    func updateViews() {
        guard let apod = apod else {
            return
        }

        let dateText = apod.date.toString()
        dateLabel.text = dateText
        cardDateLabel.text = dateText
        
        cardPhotoImageView.image = apod.photo
        cardTitleLabel.text = apod.title
        cardDescriptionLabel.text = apod.description
        
        displayViews()
    }
    
    func displayViews() {
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut]) {
            self.titleLabel.isHidden = false
            self.dateLabel.isHidden = false
            self.cardView.isHidden = false
        }
        
        UIView.animate(withDuration: 0.8, delay: 0, options: [.curveEaseOut]) {
            self.titleLabel.layer.opacity = 1
            self.dateLabel.layer.opacity = 1
            self.cardView.layer.opacity = 1
        }
    }
    
    func hideViews() {
        self.titleLabel.layer.opacity = 0
        self.dateLabel.layer.opacity = 0
        self.cardView.layer.opacity = 0
        
        titleLabel.isHidden = true
        dateLabel.isHidden = true
        cardView.isHidden = true
    }
    
    func loadData() {
        APODController.shared.fetchTodayAPOD { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.updateViews()
                    self.removeLoading(self.loadingVC, completion: {})
                case .failure(let error):
                    self.removeLoading(self.loadingVC) {
                        self.presentAlert(title: "Ops, error loading today's photo", message: error.localizedDescription)
                    }
                }
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "toDetailVC",
              let destination = segue.destination as? APODViewController,
              let apod = apod else {
            return
        }
        
        destination.apod = apod
    }

}
