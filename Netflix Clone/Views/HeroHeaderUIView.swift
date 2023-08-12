//
//  HeroHeaderUIView.swift
//  Netflix Clone
//
//  Created by Yash Patil on 26/07/23.
//

import UIKit
import SDWebImage

class HeroHeaderUIView: UIView {

    let playButtonView : UIButton = {
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let downloadButtonView : UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let imageHeaderView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
    //    imageView.image = UIImage(named: "heroImage")
        imageView.clipsToBounds = true
        return imageView
    }()

    func applyGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.systemBackground.cgColor]
        layer.addSublayer(gradient)
    }


    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageHeaderView)
        applyGradient()
        addSubview(playButtonView)
        addSubview(downloadButtonView)
        applyConstraints()
    }

    func applyConstraints() {
        NSLayoutConstraint.activate([
            playButtonView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 60),
            playButtonView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -25),
            playButtonView.widthAnchor.constraint(equalToConstant: 100),

            downloadButtonView.leadingAnchor.constraint(equalTo: playButtonView.trailingAnchor, constant: 30),
            downloadButtonView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -25),
            downloadButtonView.widthAnchor.constraint(equalToConstant: 120)
        ])
    }

    func configure(with model: String) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(model)") else { print("Error fetching image"); return }
        imageHeaderView.sd_setImage(with: url)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageHeaderView.frame = bounds
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
