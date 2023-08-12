//
//  APICaller.swift
//  Netflix Clone
//
//  Created by Yash Patil on 27/07/23.
//

import Foundation


struct Constants {
    static let API_Key = "697d439ac993538da4e3e60b54e762cd"
    static let baseURL = "https://api.themoviedb.org"
    static let YoutubeAPIKey = "AIzaSyBXCuv1YLyYvcLXlHMSbuRIsaeYQR0tlNM"
    static let YoutubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
}

enum APIError:  Error {

    case failedTogetError(error: Error)

    var errorDescription: String? {
        switch self {
        case .failedTogetError(error: let error): return "Failed, Error occured: \(error.localizedDescription) and in raw :\(error)"
        
        }
    }
}


class APICaller {

    static let shared = APICaller()

    func getTrendingMovies(completion : @escaping (Result<[Title], Error>) -> ()) {
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/movie/day?api_key=\(Constants.API_Key)") else { return }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data,error == nil else { return }
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
               
                completion(.success(results.results))

            }catch let error {
                print("Error: \(error.localizedDescription)")
                completion(.failure(error))
            }

        }
        task.resume()

    }

    func getPopular(completion : @escaping (Result<[Title], Error>) -> ()) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/popular?api_key=\(Constants.API_Key)&language=en-US&page=1") else { return }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data,error == nil else { return }
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))

            }catch let error {
                completion(.failure(error))
            }

        }
        task.resume()

    }

    func getUpcomingMovies(completion : @escaping (Result<[Title], Error>) -> ()) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/upcoming?api_key=\(Constants.API_Key)&language=en-US&page=1") else { return }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data,error == nil else { return }
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))

            }catch let error {
                completion(.failure(error))
            }

        }
        task.resume()

    }

    func getTopRated(completion : @escaping (Result<[Title], Error>) -> ()) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/top_rated?api_key=\(Constants.API_Key)&language=en-US&page=1") else { return }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data,error == nil else { return }
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))

            }catch let error {
                completion(.failure(error))
            }

        }
        task.resume()

    }


    func getTrendingTvs(completion : @escaping (Result<[Title], Error>) -> ()) {
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/tv/day?api_key=\(Constants.API_Key)") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data,error == nil else { return }
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))


            }catch let error {
                completion(.failure(error))
            }
        }
        task.resume()

    }

    func getDiscoverMovies(completion : @escaping (Result<[Title], Error>) -> ()) {
        
        guard let url = URL(string: "\(Constants.baseURL)/3/discover/movie?api_key=\(Constants.API_Key)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types-flatrate") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data,error == nil else { return }
            do {

                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)

                completion(.success(results.results))

            }catch let error {

                completion(.failure(error))
            }

        }
        task.resume()

    }

    func search(with query: String, completion: @escaping (Result<[Title], Error>) -> ()) {

        guard let url = URL(string: "\(Constants.baseURL)/3/search/movie?api_key=\(Constants.API_Key)&query=\(query)") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data,error == nil else { return }
            do {

                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)

                completion(.success(results.results))

            }catch let error {

                completion(.failure(error))
            }

        }
        task.resume()

    }

    func getYoutubeMovie(with query: String, completion: @escaping (Result<VideoElement, Error>) -> ()) {

        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return }
        guard let url = URL(string: "\(Constants.YoutubeBaseURL)q=\(query)&key=\(Constants.YoutubeAPIKey)") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            if let data, error == nil {
                do {
                    let results = try JSONDecoder().decode(YoutubeSearchResults.self, from: data)
                    completion(.success(results.items[0]))
                    print(results.items.first!.id.videoId)
                }catch let error {
                    completion(.failure(error))
                }
            }else {
                print("Error fetching the data")
            }
        }

        task.resume()


    }
}
