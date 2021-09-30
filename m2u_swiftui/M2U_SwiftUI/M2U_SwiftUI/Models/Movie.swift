//
//  Movie.swift
//  M2U_SwiftUI
//
//  Created by Yan Akhrameev on 29/09/21.
//

import Foundation

struct Movies: Codable {
    let results: [Movie]
}

struct Movie: Codable, Identifiable {
    var id: String {
        return name
    }
    
    let name: String
    var likes: Int
    var views: Double
    let year: String
    let image: String
    
    
    enum CodingKeys: String, CodingKey {
        case name = "original_title"
        case likes = "vote_count"
        case views = "popularity"
        case year = "release_date"
        case image = "poster_path"
    }
}
