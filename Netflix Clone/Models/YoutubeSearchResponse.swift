//
//  YoutubeSearchResponse.swift
//  Netflix Clone
//
//  Created by Nisa Aydin on 24.03.2024.
//

import Foundation

struct YoutubeSearchResponse: Codable {
    let items: [VideoElement]
}


struct VideoElement: Codable {
    let id: IdVideoElement
}


struct IdVideoElement: Codable {
    let kind: String
    let videoId: String
    private enum CodingKeys: String, CodingKey {
          case kind
          case videoId = "videoId"
      }
  
}
