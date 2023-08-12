//
//  GenericNavViewController.swift
//  Netflix Clone
//
//  Created by Yash Patil on 05/08/23.
//

import Foundation
import UIKit


func GenericNavController(viewController: UIViewController, forTitles titles: [Title], forIndexPath indexPath: IndexPath) {

    let selectedTitle = titles[indexPath.row]
    let vc = TitlePreviewViewController()

    APICaller.shared.getYoutubeMovie(with: selectedTitle.original_title! + " trailer") { results in
        switch results {
        case .success(let videoElement):
            DispatchQueue.main.async {
                let viewModel = TitlePreviewViewModel(title: selectedTitle.original_title ?? "No title", youtubeView: videoElement, titleOverview: selectedTitle.overview)

                vc.configure(with: viewModel)
                viewController.navigationController?.pushViewController(vc, animated: true)

            }

        case .failure(let error):  print(APIError.failedTogetError(error: error).errorDescription!)
        }
    }
}
