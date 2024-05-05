//
//  Movie.swift
//  Netflix Clone
//
//  Created by Nisa Aydin on 20.03.2024.
//

import Foundation
struct TrendingMovieResponse : Codable {
    let results : [Movie]
    
    
}

struct Movie : Codable {
    let id: Int
    let media_type: String?
    let original_title: String?
    let overview: String?
    let poster_path: String?
    let vote_count: Int
    let release_date: String?
    let vote_average: Double
}

