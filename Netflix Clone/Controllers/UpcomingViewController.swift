//
//  UpcomingViewController.swift
//  Netflix Clone
//
//  Created by Yash Patil on 25/07/23.
//

import UIKit

class UpcomingViewController: UIViewController {

    private var titles : [Title] = []

    private let upcomingTable : UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.id)
        return table
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.title = "Upcoming"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always


        view.addSubview(upcomingTable)
        upcomingTable.dataSource = self
        upcomingTable.delegate = self

        fetchData()
        // Do any additional setup after loading the view.
    }

    func fetchData() {
        APICaller.shared.getUpcomingMovies { [weak self] result in
            switch result {
            case .success(let titles): self?.titles = titles
                DispatchQueue.main.async {
                    self?.upcomingTable.reloadData()
                }
            case .failure(let error): print("Error intializing upcoming movies: \(error)")
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
    }

}


extension UpcomingViewController : UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.id, for: indexPath) as? TitleTableViewCell else {return UITableViewCell() }
        let title = titles[indexPath.row]
        cell.configure(with: title.original_title ?? "No title", for: title.poster_path ?? "No poster")
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        GenericNavController(viewController: self, forTitles: titles, forIndexPath: indexPath)

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

}
