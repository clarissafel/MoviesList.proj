//
//  Model.swift
//
//  Created by Clarissa Nurawan on 3/4/21.
//

import Foundation

//For movie list from Discover API
struct MoviesList: Decodable {
    let movies: [Movie]
    let totalPages: Int
    
    private enum CodingKeys: String, CodingKey {
        case movies = "results"
        case totalPages = "total_pages"
    }
}

struct Movie: Decodable {
    let title: String?
    let releaseDate: String?
    let rating: Double?
    let poster: String?
    let sypnosis: String?
    let id: Int?
    
    private enum CodingKeys: String, CodingKey {
        case title, id
        case releaseDate = "release_date"
        case rating = "vote_average"
        case poster = "poster_path"
        case sypnosis = "overview"
    }
}

//For details from Details API
struct MovieDetails : Codable {
    var poster: String?
    var title: String?
    var releaseDate: String?
    var duration: Int?
    var language: String?
    var sypnosis: String?
    var genres: [Genre]?
    
    private enum CodingKeys: String, CodingKey{
        case title
        case poster = "poster_path"
        case releaseDate = "release_date"
        case duration = "runtime"
        case language = "original_language"
        case sypnosis = "overview"
        case genres = "genres"
    }
 
}

struct Genre : Codable {
    var id:Int?
    var name: String?
    
    private enum CodingKeys: String, CodingKey{
        case id, name
    }
    
}
