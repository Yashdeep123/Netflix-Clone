//
//  TitleTableViewCell.swift
//  Netflix Clone
//
//  Created by Yash Patil on 30/07/23.
//

import UIKit
import SDWebImage

class TitleTableViewCell: UITableViewCell {

    static let id = "TitleTableViewCell"

    private var playTitleButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        return button
    }()

    private var titleLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.numberOfLines = 2
        return title
    }()
    
    private var titlesPosterImageView : UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titlesPosterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(playTitleButton)
        applyConstraints()
    }

    func applyConstraints() {
        NSLayoutConstraint.activate([
            titlesPosterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titlesPosterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            titlesPosterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            titlesPosterImageView.widthAnchor.constraint(equalToConstant: 100),
            

            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: titlesPosterImageView.trailingAnchor, constant: 15),
            titleLabel.widthAnchor.constraint(equalToConstant: 230),

            playTitleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            playTitleButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)


        ])
    }

    func configure(with titleName: String, for posterURL: String) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(posterURL)") else {return }
        titlesPosterImageView.sd_setImage(with: url)
        titleLabel.text = titleName
    }

    required init?(coder: NSCoder) {
        fatalError("Error constructing TableView Cell")
    }
}
