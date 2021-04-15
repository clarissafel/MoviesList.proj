//
//  MovieTableViewCell.swift
//
//  Created by Clarissa Nurawan on 3/4/21.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieDate: UILabel!
    @IBOutlet weak var movieRating: UILabel!
    @IBOutlet weak var movieSypnosis: UILabel!
    
    private var urlString: String = ""
    
    // Setup movies values
    func setCellValues(_ cellMovie:Movie) {
        updateUI(title: cellMovie.title, releaseDate: cellMovie.releaseDate, rating: cellMovie.rating, sypnosis: cellMovie.sypnosis, poster: cellMovie.poster)
    }

    private func updateUI(title: String?, releaseDate: String?, rating: Double?, sypnosis: String?, poster: String?) {
        
        self.movieTitle.text = title
        self.movieDate.text = convertDateFormater(releaseDate)
        guard let rate = rating else {return}
        self.movieRating.text = String(rate)
        self.movieSypnosis.text = sypnosis
        
        guard let posterString = poster else {return}
        urlString = "https://image.tmdb.org/t/p/w300" + posterString
        
        guard let posterImageURL = URL(string: urlString) else {
            self.moviePoster.image = UIImage(named: "noImageAvailable")
            return
        }
        
        // Clear old image before loading new one
        self.moviePoster.image = nil
        
        getImage(url: posterImageURL)
        
    }

    func getImage(url: URL) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("Empty Data")
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    self.moviePoster.image = image
                }
            }
        }.resume()
    }
    
    func convertDateFormater(_ date: String?) -> String {
        var fixDate = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let originalDate = date {
            if let newDate = dateFormatter.date(from: originalDate) {
                dateFormatter.dateFormat = "dd.MM.yyyy"
                fixDate = dateFormatter.string(from: newDate)
            }
        }
        return fixDate
    }
}
