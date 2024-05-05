//
//  Title.swift
//  Netflix Clone
//
//  Created by Nisa Aydin on 21.03.2024.
//

import Foundation
struct TrendingTitleResponse: Codable {
    let results: [Title]
    
}

struct Title: Codable{
    let id: Int
    let media_type: String?
    let original_title: String?
    let original_name: String?
    let overview: String?
    let poster_path: String?
    let vote_count: Int
    let release_date: String?
    let vote_average: Double
    
}
