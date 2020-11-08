//
//  UserDefaults+Cell.swift
//  IMusic
//
//  Created by Kirill Manvelov on 19.08.2020.
//  Copyright © 2020 Kirill Manvelov. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    static let favouriteTracksKey = "favouriteTracksKey"
    
    func savedTracks() -> [SearchViewModel.Cell] {
        let defaults = UserDefaults.standard
        guard let data = defaults.data(forKey: "favouriteTracksKey") else {
            return []
        }
        guard let decodedTracks = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [SearchViewModel.Cell] else {
            return []
        }
        return decodedTracks
    }
}
