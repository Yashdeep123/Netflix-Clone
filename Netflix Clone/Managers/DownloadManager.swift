//
//  DownloadManager.swift
//  Netflix Clone
//
//  Created by Yash Patil on 07/08/23.
//

import Foundation
import CoreData


enum DownloadError: Error {
    case SaveError
    case FetchError
    case deleteError
}

class DownloadManager {
    static let shared = DownloadManager()

    lazy var persistentContainer : NSPersistentContainer = {

        let container = NSPersistentContainer(name: "DownloadContainer")
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Unresolved Error: \(error)")
            }else {
                print("Successfull loading containers.")
            }
        }
        return container
    }()

    func saveContext() {
        let context = persistentContainer.viewContext

        if context.hasChanges {
            do {
                try context.save()
            }catch let error {
                print("Error saving:\(error.localizedDescription)")
            }
        }
    }

    func downloadTitleWith(model: Title, completion: @escaping (Result<Void, Error>) -> ()) {

        let context =  self.persistentContainer.viewContext

        let item = TitleItem(context: context)


        item.id = Int64(model.id)
        item.original_title = model.original_title
        item.original_language = model.original_language
        item.overview = model.overview
        item.media_type = model.overview
        item.poster_path = model.poster_path
        item.release_date = model.release_date
        item.vote_count = Int64(model.vote_count)
        item.vote_average = model.vote_average

        print("Successfull \(item)")

        do {
            try context.save()
            completion(.success(()))
        }catch  {
            completion(.failure(DownloadError.SaveError))
        }
    }

    func fetchTitles(completion: @escaping (Result<[TitleItem], Error>) -> Void) {

        let context = DownloadManager.shared.persistentContainer.viewContext

        let request = TitleItem.fetchRequest()

        do {
           let titles = try context.fetch(request)
            completion(.success(titles))
        } catch {
            completion(.failure(DownloadError.FetchError))
        }
    }

    func deleteTitleWith(model: TitleItem, completion: @escaping (Result<Void, Error>) -> ()) {

        let context = self.persistentContainer.viewContext
        context.delete(model)

        do {
            try context.save()
            completion(.success(()))
        }catch {
            completion(.failure(DownloadError.deleteError))
        }

    }


}
