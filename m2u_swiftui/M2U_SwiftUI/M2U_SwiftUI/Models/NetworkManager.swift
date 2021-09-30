//
//  NetworkManager.swift
//  M2U_SwiftUI
//
//  Created by Yan Akhrameev on 29/09/21.
//

import Foundation
import UIKit
import SwiftUI


class NetworkManager: ObservableObject {
    
    // MARK: - Properties:
    
    @Published var movie: Movie?
    @Published var image: UIImage?
    @Published var movies: Movies? = Movies(results: [Movie]())
    
    private let baseURL = "https://api.themoviedb.org/3/movie/111"
    private let imageURL = "https://image.tmdb.org/t/p/w500"
    
    // MARK: - Methods:
    
    func fetchMovie() {
        guard var urlComponents = URLComponents(string: baseURL) else {return}
        urlComponents.queryItems = ["api_key" : "03269f4b09e5bcabf8f5481a800ac72d"].map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        if let url = urlComponents.url {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if error == nil {
                    let decoder = JSONDecoder()
                    if let data = data {
                        do {
                            let movie = try decoder.decode(Movie.self, from: data)
                            DispatchQueue.main.async {
                                self.movie = movie
                                self.fetchImage(movie: self.movie)
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func fetchImage(movie: Movie?) {
        let imageForURl = URL(string: "\(imageURL)\(movie?.image ?? "")")
            if let url = imageForURl {
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    if error == nil {
                        if let data = data {
                            if let image = UIImage(data: data) {
                                DispatchQueue.main.async {
                                    self.image = image
                                }
                            }
                        }
                    }
                }
                task.resume()
            }
    }
    
    func fetchRelatedMovies() {
        var urlComponents = URLComponents(string: "\(baseURL)/similar")!
        urlComponents.queryItems = ["api_key" : "03269f4b09e5bcabf8f5481a800ac72d"].map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        let task = URLSession.shared.dataTask(with: urlComponents.url!) { (data, response, error) in
            if error == nil {
                let decoder = JSONDecoder()
                if let data = data {
                    do {
                        let movies = try decoder.decode(Movies.self, from: data)
                        DispatchQueue.main.async {
                        
                            self.movies = movies
                            
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
        task.resume()
    }
    
  
    
}
