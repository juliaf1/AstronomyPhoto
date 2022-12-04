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
        return isSearching ? filteredFavorites : FavoriteController.shared.apods
    }
    
    var isSearching: Bool = false
    var filteredFavorites: [APOD] = []
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        
        hideViews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        updateViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        displayViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        hideViews()
    }
    
    // MARK: - Helpers
    
    func configureViews() {
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
    }
    
    func updateViews() {
        countLabel.text = "\(favorites.count) astronomy photos saved"
    }

    func loadData() {
        presentLoading(loadingVC)

        FavoriteController.shared.fetchFavorites { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.updateViews()
                    self.tableView.reloadData()
                    self.removeLoading(self.loadingVC, completion: {})
                case .failure(let error):
                    self.presentAlert(title: "Ops, error fetching your favorites", message: error.localizedDescription)
                }
            }
        }
    }
    
    func hideViews() {
        titleLabel.layer.opacity = 0
        countLabel.layer.opacity = 0
        
        titleLabel.isHidden = true
        countLabel.isHidden = true
        tableView.isHidden = true
    }
    
    func displayViews() {
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut]) {
            self.titleLabel.isHidden = false
            self.countLabel.isHidden = false
            self.tableView.isHidden = false
        }
        
        UIView.animate(withDuration: 0.8, delay: 0, options: [.curveEaseOut]) {
            self.titleLabel.layer.opacity = 1
            self.countLabel.layer.opacity = 1
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

    func toggleFavorite(for cell: APODTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        let apod = favorites[indexPath.row]
        
        FavoriteController.shared.unfavorite(apod: apod) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.updateViews()
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                case .failure(let error):
                    self.presentAlert(title: "Error removing from favorite", message: error.localizedDescription)
                }
            }
        }
    }

}

extension FavoritesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
        } else {
            isSearching = true
            filteredFavorites = favorites.filter { $0.matches(searchTerm: searchText) }
        }
        
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

}
