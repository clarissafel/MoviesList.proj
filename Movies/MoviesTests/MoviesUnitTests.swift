//
//  MoviesUnitTests.swift
//  MoviesTests
//
//  Created by Clarissa Nurawan on 4/4/21.
//

import XCTest
@testable import Movies

class MoviesUnitTests: XCTestCase {
    
    func test_fetchLatestMoviesApi_Valid(){
        let api = ApiService()
        api.getLatestMovies(page: 1, date: "2021-02-02"){ (MoviesList) in
            XCTAssertNotNil(MoviesList)
        }
    }
    
    func test_fetchDetailsApi_Valid() {
        let api = ApiService()
        api.getDetails(id: 813070){ (MoviesList) in
            XCTAssertNotNil(MoviesList)
            
        }
    }
}
