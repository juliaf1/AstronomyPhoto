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
    @IBOutlet weak var cardPhoto: UIImageView!
    @IBOutlet weak var cardTitleLabel: UILabel!
    @IBOutlet weak var cardDescriptionLabel: UILabel!
    @IBOutlet weak var cardDateLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!

    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        
        titleLabel.isHidden = true
        dateLabel.isHidden = true
        cardView.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutViews()
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        presentLoading()
    }
    
    // MARK: - Actions
    
    @IBAction func didPressFavoriteButton(_ sender: UIButton) {
    }
    
    // MARK: Helpers
    
    func presentLoading() {
        loadingVC.modalPresentationStyle = .overCurrentContext
        loadingVC.modalTransitionStyle = .crossDissolve
        
        present(loadingVC, animated: true)
    }
    
    func removeLoading() {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear]) {
            self.loadingVC.view.alpha = 0
        } completion: { _ in
            self.loadingVC.dismiss(animated: false)
        }
    }
    
    func layoutViews() {
        // Round photo top corners
        let path = UIBezierPath(roundedRect: cardPhoto.bounds,
                                byRoundingCorners: [.topRight, .topLeft],
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
    
    func updateViews() {
        guard let apod = apod else {
            return
        }

        let dateText = apod.date.toString()
        dateLabel.text = dateText
        cardDateLabel.text = dateText

        cardTitleLabel.text = apod.title
        cardDescriptionLabel.text = apod.description
        
        displayViews()
    }
    
    func displayViews() {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut]) {
            self.titleLabel.isHidden = false
            self.dateLabel.isHidden = false
            self.cardView.isHidden = false
        }
    }
    
    func loadData() {
        APODController.shared.fetchTodayAPOD { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.updateViews()
                case .failure(let error):
                    print(error)
                    // TODO: Present action sheet alert
                }
                self.removeLoading()
            }
        }
    }

}
