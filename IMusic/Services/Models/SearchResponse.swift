//
//  SearchResponse.swift
//  IMusic
//
//  Created by Kirill Manvelov on 27.07.2020.
//  Copyright © 2020 Kirill Manvelov. All rights reserved.
//

import Foundation

struct SearchResponse: Decodable {
    var resultCount: Int
    var results: [Track]
}


struct Track: Decodable {
    var trackName: String
    var collectionName: String?
    var artistName: String
    var artworkUrl100: String?
    var previewUrl: String?
}
