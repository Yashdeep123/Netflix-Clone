//
//  TitleCollectionViewCell.swift
//  Netflix Clone
//
//  Created by Yash Patil on 28/07/23.
//

import UIKit
import SDWebImage

class TitleCollectionViewCell: UICollectionViewCell {

    static let id = "TitleCollectionViewCell"

    private let loadingView: UIActivityIndicatorView = {
        let loading = UIActivityIndicatorView()
        loading.translatesAutoresizingMaskIntoConstraints = false
        return loading
    }()

    private let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        return iv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
    }

    func configure(with model: String) {
        // "https: //image. tmdb.org/t/p/w500/\
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(model)") else { return }
        posterImageView.sd_setImage(with: url)
    }

    required init?(coder: NSCoder) {
        fatalError("Failed to initalize the collectionViewCell")
    }

}
