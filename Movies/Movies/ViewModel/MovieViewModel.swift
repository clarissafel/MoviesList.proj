//
//  MovieViewModel.swift
//
//  Created by Clarissa Nurawan on 3/4/21.
//

import Foundation

class MovieViewModel {
    
    private var apiService = ApiService()
    
    var latestMovies = [Movie]()
    var totalPages = 1
    var currentPage = 1
    
    func fetchLatestMovies(page currentPage: Int, completion: @escaping () -> ()) {

        apiService.getLatestMovies (page: currentPage, date: getCurrentDate()){ [weak self] (result) in
            switch result {
            case .success(let listOf):
                print("Success")
                self?.totalPages = listOf.totalPages
                self?.latestMovies.append(contentsOf: listOf.movies)
                completion()
                
            // Error with JSON file or model
            case .failure(let error):
                print("Error processing json data: \(error)")
            }
        }
    }
    
    func getCurrentDate() -> String {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let formattedDate = format.string(from: date)
        return formattedDate
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        print("in numberOfRowsInSection")
        if latestMovies.count != 0 {
            //return number of movies in page
            return latestMovies.count
        }
        return 0
    }
    
    func cellForRowAt (indexPath: IndexPath) -> Movie {
        return latestMovies[indexPath.row]
    }
    
    func searchMovie(title movieTitle: String){
        
        let searchedMovie = latestMovies.filter { (Movie) -> Bool in
            if (Movie.title == movieTitle) {
                return true }
            else {
                return false }
        }
        print(searchedMovie)
        
    }
}
