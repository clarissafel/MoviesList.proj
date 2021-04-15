//
//  ApiService.swift
//
//  Created by Clarissa Nurawan on 3/4/21.
//

import Foundation

class ApiService {
    
    private var movieDataTask: URLSessionDataTask?
    private var detailsDataTask: URLSessionDataTask?
    
    //To get latest movie list, ordered by release date
    func getLatestMovies( page currentPage : Int, date limitDate: String, completion: @escaping (Result<MoviesList, Error>) -> Void) {
        
        let popularMoviesString = "https://api.themoviedb.org/3/discover/movie?api_key=328c283cd27bd1877d9080ccb1604c91&language=en-US&sort_by=release_date.desc"
        
        //Set params
        let pageString = String(currentPage)
        let params = "&release_date.lte=\(limitDate)&page=\(pageString)"
        let popularMoviesURL = "\(popularMoviesString)\(params)"
        print("popularMoviesURL: \(popularMoviesURL)")
        
        guard let url = URL(string: popularMoviesURL) else {return}

        // Create URL Session
        movieDataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            // Handle Error
            if let error = error {
                completion(.failure(error))
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            //Handle Empty Response
            guard let response = response as? HTTPURLResponse else {
                print("Empty Response")
                return
            }
            print("Response status code: \(response.statusCode)")
            
            //Handle Empty Data
            guard let data = data else {
                print("Empty Data")
                return
            }
            
            do {
                // Parse the data
                let decoder = JSONDecoder()
                let moviesListData = try decoder.decode(MoviesList.self, from: data)
                print("moviesListData: \(moviesListData)")

                DispatchQueue.main.async {
                    completion(.success(moviesListData))
                }
            } catch let error {
                completion(.failure(error))
            }
            
        }
        movieDataTask?.resume()
    }

    //To get details of movie, by movie id
    func getDetails(id movieId: Int, completion: @escaping (Result<MovieDetails, Error>) -> Void) {
        print("Entering getDetails of movie id: \(movieId)")

        let id = String(movieId)
        let movieDetailURL = "https://api.themoviedb.org/3/movie/\(id)?api_key=328c283cd27bd1877d9080ccb1604c91&language=en-US"
        print("movieDetailURL: \(movieDetailURL)")

        let url = URL(string: movieDetailURL)
        guard url != nil else {
            return
        }

        detailsDataTask = URLSession.shared.dataTask(with: url!) { (data, response, error) in

            
            if error == nil && data != nil {

                //parse json
                let decoder = JSONDecoder()

                guard let data = data else {
                    // Handle Empty Data
                    print("Empty Data")
                    return
                }

                do {
                    let detailsData = try decoder.decode(MovieDetails.self, from: data)
                    print("detailsData: \(detailsData)")
                    print("detailsData: \(String(describing: detailsData.title))")
                    
                    // Back to the main thread
                    DispatchQueue.main.async {
                        completion(.success(detailsData))
                    }

                } catch{
                    print("Error in json parsing")
                }

            }
        }

        detailsDataTask?.resume()
    }

}
