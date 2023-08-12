//
//  DownloadsViewController.swift
//  Netflix Clone
//
//  Created by Yash Patil on 25/07/23.
//

import UIKit

class DownloadsViewController: UIViewController {


    private var fetchedTitles: [TitleItem] = []
    private var titles: [Title] = []

    private let downloadTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.id)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(downloadTable)

        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .automatic

        downloadTable.dataSource = self
        downloadTable.delegate = self

        downloadData()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.downloadData()
        self.transferItemToTitle()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadTable.frame = view.bounds
    }

    func downloadData() {

        DownloadManager.shared.saveContext()
        
        DownloadManager.shared.fetchTitles { result in
            switch result {
            case .success(let fetchedTitles):
                DispatchQueue.main.async {
                    self.fetchedTitles = self.removeDuplications(for: fetchedTitles)
                    self.downloadTable.reloadData()
                }
            case .failure(let error): print("Failed to fetch : \(error.localizedDescription)")
            }
        }
    }

    func removeDuplications(for arr: [TitleItem]) -> [TitleItem] {
       var uniqueElements: [TitleItem] = []
       for x in arr {
          if !uniqueElements.contains(x) {
             uniqueElements.append(x)
          }
       }
       return uniqueElements
    }

    func transferItemToTitle() {


        for titleItem in self.fetchedTitles {
            let title = Title(id: Int(titleItem.id), media_type: titleItem.media_type, original_language: titleItem.original_language, original_title: titleItem.original_title, overview: titleItem.overview ?? "No overview", poster_path: titleItem.poster_path, release_date: titleItem.release_date, vote_average: titleItem.vote_average, vote_count: Int(titleItem.vote_count))
            self.titles.append(title)
        }
    }

}

extension DownloadsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedTitles.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.id, for: indexPath) as? TitleTableViewCell else { return UITableViewCell() }
        let title = self.fetchedTitles[indexPath.row]
        cell.configure(with: title.original_title ?? "No title", for: title.poster_path ?? "No image")
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            DownloadManager.shared.deleteTitleWith(model: fetchedTitles[indexPath.row]) { result in
                switch result {
                case .success():
                    self.fetchedTitles.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .automatic)

                case .failure(let error): print("Failed Deleting the item : \(error.localizedDescription)")
                }

            }
        default: break
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        GenericNavController(viewController: self, forTitles: self.titles, forIndexPath: indexPath)
    }


}
