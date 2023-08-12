//
//  HomeViewController.swift
//  Netflix Clone
//
//  Created by Yash Patil on 25/07/23.
//

import UIKit

enum Sections: Int {
    case TrendingMovies = 0
    case TrendingTvs = 1
    case Popular = 2
    case UpcomingMovies = 3
    case TopRated = 4
}

class HomeViewController: UIViewController {

    var sectionTitles = ["Trending Movies","Trending Tv","Popular","Upcoming Movies", "Top rated"]

    private var headerView: HeroHeaderUIView?
    private var randomElement: Title?

    private let NetflixImageView: UIImageView = {
        let ImageView = UIImageView()
        ImageView.image = UIImage(named: "NetflixLogo")?.withRenderingMode(.alwaysOriginal)
        ImageView.translatesAutoresizingMaskIntoConstraints = false
        return ImageView
    }()

    private let homeFeedTable : UITableView = {
        let tv = UITableView(frame: .zero,style: .grouped)
        tv.register(CollectionViewTableViewCell.self,forCellReuseIdentifier: CollectionViewTableViewCell.id)

        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)

        homeFeedTable.dataSource = self
        homeFeedTable.delegate = self

        configureNavBar()
        applyConstraints()

        headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 550))

        APICaller.shared.getPopular { result in
            switch result {
            case .success(let title):
                self.randomElement = title.randomElement()!
                if let element = self.randomElement, let path = element.poster_path {
                    self.headerView?.configure(with: path)
                }else { print("Error")}

            case .failure(let error): print("Error fetching random element \(error.localizedDescription)")
            }
        }

        self.homeFeedTable.tableHeaderView = headerView


        // Do any additional setup after loading the view.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }


    func applyConstraints() {

        NSLayoutConstraint.activate([
            NetflixImageView.widthAnchor.constraint(equalToConstant: 25),
            NetflixImageView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    func configureNavBar() {

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: NetflixImageView)

        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]

        navigationController?.navigationBar.tintColor = .white
    }

   

}


extension HomeViewController : UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }


    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {

        guard let header = view as? UITableViewHeaderFooterView else {return }
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()

    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.id ,for: indexPath) as? CollectionViewTableViewCell else { print("Failed to create custom TableView cell"); return UITableViewCell() }

        cell.delegate = self
        switch indexPath.section {

        case Sections.TrendingMovies.rawValue:
            APICaller.shared.getTrendingMovies { result in
                switch result {
                case .success(let titles):
                    return cell.configure(with: titles)
                case .failure(let error): print("Failure fetching Trending Movies :\(error.localizedDescription)")
                }
            }
            
        case Sections.TrendingTvs.rawValue:
            APICaller.shared.getTrendingTvs { result in
                switch result {
                case .success(let titles):
                    return cell.configure(with: titles)
                case .failure(let error): print("Failure fetching Trending Tv :\(error.localizedDescription)")

                }
            }
        case Sections.Popular.rawValue:
            APICaller.shared.getPopular { result in
                switch result {
                case .success(let titles):
                    return cell.configure(with: titles)
                case .failure(let error): print("Failure fetching Popular :\(error.localizedDescription)")

                }
            }
        case Sections.UpcomingMovies.rawValue:
            APICaller.shared.getUpcomingMovies { result in
                switch result {
                case .success(let titles):
                    return cell.configure(with: titles)
                case .failure(let error): print("Failure fetching upcoming Movies :\(error.localizedDescription)")

                }
            }
        case Sections.TopRated.rawValue: APICaller.shared.getTopRated { result in
            switch result {
            case .success(let titles):

                return cell.configure(with: titles)
            case .failure(let error): print("Failure fetching Top rated:\(error)")

            }
        }
        default:
            return UITableViewCell()
        }
        return cell
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}

extension HomeViewController: CollectionViewTableViewCellDelegate {
    func collectionTableViewDidTapCell(viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }

    }
}
