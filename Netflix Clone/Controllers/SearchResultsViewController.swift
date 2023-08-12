//
//  SearchResultsViewController.swift
//  Netflix Clone
//
//  Created by Yash Patil on 31/07/23.
//

import UIKit
import WebKit

class SearchResultsViewController: UIViewController {

    public var titles: [Title] = []

    public var searchResultCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width / 3) - 10, height: 200)
        layout.minimumInteritemSpacing = 10
        cv.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.id)

        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(searchResultCollectionView)

        searchResultCollectionView.delegate = self
        searchResultCollectionView.dataSource = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultCollectionView.frame = view.bounds
    }

}


extension SearchResultsViewController : UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.id, for: indexPath) as? TitleCollectionViewCell else { return UICollectionViewCell() }
        let title = titles[indexPath.row]
        cell.configure(with: title.poster_path ?? "")
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if let parentVC = self.presentingViewController {
            print("Working: \(parentVC)")
            GenericNavController(viewController: parentVC, forTitles: self.titles, forIndexPath: indexPath)
        }else { print("Failed converting to parentVC.") }


    }
}
