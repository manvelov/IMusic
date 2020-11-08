//
//  SearchModels.swift
//  IMusic
//
//  Created by Kirill Manvelov on 29.07.2020.
//  Copyright (c) 2020 Kirill Manvelov. All rights reserved.
//

import UIKit
import SwiftUI

enum Search {
    
    enum Model {
        struct Request {
            enum RequestType {
                case getTracks(searchTerm: String)
            }
        }
        struct Response {
            enum ResponseType {
                case presentTracks(searchResponse: SearchResponse?)
                case presentFooterView
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case displayCells(searchViewModel: SearchViewModel)
                case displayFooterView
            }
        }
    }
    
}

class SearchViewModel: NSObject, NSCoding{
    
    // MARK: -nested class Cell
    @objc(_TtCC6IMusic15SearchViewModel4Cell)class Cell: NSObject, NSCoding, Identifiable  {
        
        var Id = UUID()
        var iconUrlString: String?
        var trackName: String
        var artistName: String
        var collectionName: String
        var previewUrl: String?
        
        init(iconUrlString: String?,
             trackName: String,
             artistName: String,
             collectionName: String,
             previewUrl: String?
        ) {
            self.iconUrlString = iconUrlString
            self.trackName = trackName
            self.artistName = artistName
            self.collectionName = collectionName
            self.previewUrl = previewUrl
        }
        // MARK: - encode, init for Cell
        func encode(with coder: NSCoder) {
            coder.encode(iconUrlString, forKey: "iconUrlString")
            coder.encode(trackName, forKey: "trackName")
            coder.encode(artistName, forKey: "artistName")
            coder.encode(collectionName, forKey: "collectionName")
            coder.encode(previewUrl, forKey: "previewUrl")
        }
        
        required init?(coder: NSCoder) {
            iconUrlString = coder.decodeObject(forKey: "iconUrlString") as? String? ?? ""
            trackName = coder.decodeObject(forKey: "trackName") as? String ?? ""
            artistName = coder.decodeObject(forKey: "artistName") as? String ?? ""
            collectionName = coder.decodeObject(forKey: "collectionName") as? String ?? ""
            previewUrl = coder.decodeObject(forKey: "previewUrl") as? String? ?? ""
        }
        
    }
    
    init(cells: [SearchViewModel.Cell]) {
        self.cells = cells
    }
    
    let cells: [Cell]
    
    // MARK: encode, init implementation for SearchViewModel
    func encode(with coder: NSCoder) {
        coder.encode(cells, forKey: "cells")
    }
    
    required init?(coder: NSCoder) {
        cells = coder.decodeObject(forKey: "cells") as? [SearchViewModel.Cell] ?? []
    }
}


