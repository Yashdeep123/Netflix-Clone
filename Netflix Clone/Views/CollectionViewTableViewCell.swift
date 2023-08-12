//
//  CollectionViewTableViewCell.swift
//  Netflix Clone
//
//  Created by Yash Patil on 25/07/23.
//

import UIKit

protocol CollectionViewTableViewCellDelegate: AnyObject {
    func collectionTableViewDidTapCell(viewModel: TitlePreviewViewModel)
}

class CollectionViewTableViewCell: UITableViewCell {

    static let id = "CollectionViewTableViewCell"

    weak var delegate: (CollectionViewTableViewCellDelegate)?

    private var titles: [Title] = []

    private let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.id)
        return cv
    }()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemRed
        contentView.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }

    public func configure(with titles: [Title]) {
        self.titles = titles
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }

    private func downloadDataAt(indexPath: IndexPath) {

        let title = titles[indexPath.row]
        DownloadManager.shared.downloadTitleWith(model: title) { result in
            switch result {
            case .success(): print("Successfully downloaded")
            case .failure(let error): print("Failed:\(error.localizedDescription)")
            }
        }
    }
}


extension CollectionViewTableViewCell : UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.id, for: indexPath) as? TitleCollectionViewCell else { return UICollectionViewCell() }
        if let poster = titles[indexPath.row].poster_path {
            cell.configure(with: poster)
        }else { print("Error initializing poster")}
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //   collectionView.deselectItem(at: indexPath, animated: true)

        let title = titles[indexPath.row]

        guard let titleName = title.original_title else { print("No name"); return }

        APICaller.shared.getYoutubeMovie(with: titleName + " trailer") { results in
            switch results {
            case .success(let videoElement):

                let titleName = title.original_title
                let titleOverview = title.overview
                let viewModel = TitlePreviewViewModel(title: titleName ?? "No title", youtubeView: videoElement, titleOverview: titleOverview)
                self.delegate?.collectionTableViewDidTapCell(viewModel: viewModel)
            case .failure(let error): print("Error occured: \(error)")
            }
        }

    }

    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { menu in
            let action = UIAction(title: "Download", image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in

                self.downloadDataAt(indexPath: indexPath)
            }
            let download = UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [action])
            return download
        }
        return config
    }
}
