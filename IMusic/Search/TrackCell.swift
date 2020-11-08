//
//  TrackCell.swift
//  IMusic
//
//  Created by Kirill Manvelov on 10.08.2020.
//  Copyright © 2020 Kirill Manvelov. All rights reserved.
//

import UIKit
import SDWebImage

protocol TrackCellViewModel {
    var iconUrlString: String? { get }
    var trackName: String { get }
    var artistName: String { get }
    var collectionName: String { get }
}

class TrackCell: UITableViewCell {
    
    static let reuseId = "TrackCell"
    var cell: SearchViewModel.Cell?
    
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var collectionNameLabel: UILabel!
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        trackImageView.image = nil
    }
    
    func set(viewModel: SearchViewModel.Cell) {
        self.cell = viewModel
        let savedTracks = UserDefaults.standard.savedTracks()
        let addedToLibrary = savedTracks.firstIndex { (addedCell) -> Bool in
            addedCell.trackName == self.cell?.trackName && addedCell.artistName == self.cell?.artistName
        } != nil
        
        if addedToLibrary {
            addButton.isHidden = true
        } else {
            addButton.isHidden = false
        }

        trackNameLabel.text = viewModel.trackName
        artistNameLabel.text = viewModel.artistName
        collectionNameLabel.text = viewModel.collectionName
        guard let iconUrl = URL(string: viewModel.iconUrlString ?? "") else {
            return
        }
        trackImageView.sd_setImage(with: iconUrl, completed: nil)
    }
    
    @IBAction func addTrack(_ sender: Any) {
        let defaults = UserDefaults.standard
        guard let cell = cell else {
            return
        }
        addButton.isHidden = true
        var listOfTracks = defaults.savedTracks()
        listOfTracks.append(cell)
        
        if let encodedList = try? NSKeyedArchiver.archivedData(withRootObject: listOfTracks, requiringSecureCoding: false) {
            defaults.set(encodedList, forKey: UserDefaults.favouriteTracksKey)
        }
    }
    
}
