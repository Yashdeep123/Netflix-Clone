//
//  SearchViewViewController.swift
//  Netflix Clone
//
//  Created by Yash Patil on 25/07/23.
//

import UIKit

class SearchViewController: UIViewController {


    private var titles: [Title] = []

     private var discoverTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.id)
        return table
    }()

    private var searchController: UISearchController = {
        let scon = UISearchController(searchResultsController: SearchResultsViewController())
        scon.searchBar.placeholder = "Search for a movie or Tv show"
        scon.searchBar.searchBarStyle = .default
        return scon
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(discoverTable)

        self.title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        navigationItem.searchController = searchController

        navigationController?.navigationBar.tintColor = .white

        discoverTable.dataSource = self
        discoverTable.delegate = self

        searchController.searchResultsUpdater = self

        fetchDiscoverData()
    }

    func fetchDiscoverData() {
        APICaller.shared.getDiscoverMovies { [weak self] result in
            switch result {
            case .success(let titles): self?.titles = titles
                DispatchQueue.main.async {
                    self?.discoverTable.reloadData()
                }
            case .failure(let error): print("Error intializing upcoming movies: \(error)")
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTable.frame = view.bounds

    }

}


extension SearchViewController : UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.id, for: indexPath) as? TitleTableViewCell else { return UITableViewCell() }
        let title = titles[indexPath.row]
        cell.configure(with: title.original_title ?? "No title", for: title.poster_path ?? "No poster")
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
        GenericNavController(viewController: self, forTitles: titles, forIndexPath: indexPath)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

}


extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar

        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultController = searchController.searchResultsController as? SearchResultsViewController
        else { return }

        APICaller.shared.search(with: query) { results in
            switch results {
            case .success(let titles):
                resultController.titles = titles
                DispatchQueue.main.async {
                    resultController.searchResultCollectionView.reloadData()
                }
            case .failure(let error): print("Error in searching: \(error)")
            }
        }
    }
}
