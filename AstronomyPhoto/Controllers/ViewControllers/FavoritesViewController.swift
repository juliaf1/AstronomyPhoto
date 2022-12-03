//
//  FavoritesViewController.swift
//  AstronomyPhoto
//
//  Created by Julia Frederico on 02/12/22.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    // MARK: - Properties
    
    let loadingVC = LoadingViewController()
    
    var favorites: [APOD] {
        return FavoriteController.shared.apods
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    // MARK: - Helpers
    
    func configureViews() {
        tableView.dataSource = self
        tableView.delegate = self
    }

    func loadData() {
        presentLoading(loadingVC)

        FavoriteController.shared.fetchFavorites { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.tableView.reloadData()
                    self.removeLoading(self.loadingVC, completion: {})
                case .failure(let error):
                    self.presentAlert(title: "Ops, error fetching your favorites", message: error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "toDetailVC",
              let destination = segue.destination as? APODViewController,
              let indexPath = tableView.indexPathForSelectedRow else {
            return
        }
        
        let apod = FavoriteController.shared.apods[indexPath.row]
        destination.apod = apod
    }

}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "apodCell", for: indexPath) as? APODTableViewCell else { return UITableViewCell() }
        
        cell.apod = favorites[indexPath.row]
        cell.delegate = self
        
        return cell
    }
    
}

extension FavoritesViewController: APODTableViewCellDelegate {

    func toggleFavorite(_ apod: APOD) {
        FavoriteController.shared.unfavorite(apod: apod) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.tableView.reloadData()
                case .failure(let error):
                    self.presentAlert(title: "Error removing from favorite", message: error.localizedDescription)
                }
            }
        }
    }

}
