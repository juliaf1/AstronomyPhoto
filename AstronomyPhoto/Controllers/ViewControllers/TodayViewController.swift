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

        layoutViews()
        hideViews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if apod == nil {
            presentLoading()
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
        
        cardPhoto.image = apod.photo
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
    
    func presentError(_ error: APIError) {
        let group = DispatchGroup()
        group.enter()
        loadingVC.dismiss(animated: false)
        group.leave()

        group.notify(queue: .main) {
            self.presentAlert(title: "Ops, error loading today's photo", message: error.localizedDescription)
        }
    }
    
    func loadPhoto() {
        guard let apod = apod else {
            return
        }

        APODController.shared.fetchPhoto(apod: apod) { _ in
            DispatchQueue.main.async {
                self.updateViews()
                self.removeLoading()
            }
        }
    }
    
    func loadData() {
        APODController.shared.fetchTodayAPOD { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.loadPhoto()
                case .failure(let error):
                    print(error.localizedDescription)
                    self.presentError(error)
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
