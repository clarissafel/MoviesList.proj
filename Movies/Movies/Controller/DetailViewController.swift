//
//  DetailViewController.swift
//
//  Created by Clarissa Nurawan on 4/4/21.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailPoster: UIImageView!
    @IBOutlet weak var detailTitle: UILabel!
    @IBOutlet weak var detailDate: UILabel!
    @IBOutlet weak var detailDuration: UILabel!
    @IBOutlet weak var detailLanguage: UILabel!
    @IBOutlet weak var detailGenres: UILabel!
    @IBOutlet weak var detailSypnosis: UILabel!
    
    private var viewModel = DetailsViewModel()
    private var apiService = ApiService()
    var movieDetails = MovieDetails()
    var movieTableViewCell = MovieTableViewCell()
    var movieId : Int!
    var genres = [Genre]()
    private var genreList: String = ""
    private var urlString: String = ""
    let bookingURL: String = "https://www.cathaycineplexes.com.sg/"
    
    internal static func instantiate(movieId: Int) -> DetailViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        vc.movieId = movieId
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if((movieId) != nil){
            print("Here is my movieId: \(String(describing: movieId))")
        }
        if ((movieId) != nil)
        {
            updateUI(movieId: movieId)
        }
 
    }


    //Redirects to Cathay website
    @IBAction func onClickBookNowBtn(_ sender: Any) {
        UIApplication.shared.open(URL(string: bookingURL)! as URL, options: [:] , completionHandler: nil)
    }
    
    func updateUI(movieId : Int) {
        apiService.getDetails(id: movieId){ [weak self] (result) in
            switch result {
            case .success(let listOf):
                self?.detailTitle.text = listOf.title
                self?.detailDate.text = listOf.releaseDate
                self?.detailDuration.text = String(listOf.duration!) + " min"
                self?.detailLanguage.text = "Language: " + listOf.language!
                self?.detailSypnosis.text = listOf.sypnosis
                self?.genres.append(contentsOf: listOf.genres!)
                self?.detailGenres.text = "Genres: " + (self?.getGenreList(self!.genres))!
                self?.getDetailPoster(poster: listOf.poster)

            // Something is wrong with the JSON file or the model
            case .failure(let error):
                print("Error processing json data: \(error)")
            }
        }
    }


    func getGenreList(_ genreArr: [Genre]) -> String {
        var totalGenres: Int = genreArr.count
        var i: Int = 0
        if totalGenres != 0 {
            while totalGenres != 0 {
                genreList.append(" \(genreArr[i].name!),")
                i += 1
                totalGenres -= 1
            }
            genreList.removeLast()
            return genreList
        }else {
            return "nil"
        }
    }
    
    func getDetailPoster(poster: String?){
        guard let posterString = poster else {return}
        urlString = "https://image.tmdb.org/t/p/w300" + posterString
        
        guard let posterImageURL = URL(string: urlString) else {
            self.detailPoster.image = UIImage(named: "noImageAvailable")
            return
        }

        self.detailPoster.image = nil
        
        getImage(url: posterImageURL)
    }
    
    private func getImage(url: URL) {
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
                    self.detailPoster.image = image
                }
            }
        }.resume()
    }
    


}
