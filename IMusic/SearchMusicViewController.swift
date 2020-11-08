//
//  SearchViewController.swift
//  IMusic
//
//  Created by Kirill Manvelov on 27.07.2020.
//  Copyright © 2020 Kirill Manvelov. All rights reserved.
//

import UIKit
import Alamofire

class SearchMusicViewController: UITableViewController {
    
    var networkService = NetworkService()
    private var timer: Timer?
    
    // adding Search Controller to view
    let searchController = UISearchController(searchResultsController: nil)
    
    var tracks = [Track]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tracks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(tracks[indexPath.row].trackName)\n\(tracks[indexPath.row].artistName)"
        cell.textLabel?.numberOfLines = 2
        return cell
    }
    
}

extension SearchMusicViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //print(searchText)
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.networkService.fetchTrack(searchText: searchText) { [weak self] (response) in
                self?.tracks = response?.results ?? []
                self?.tableView.reloadData()
            }
            
        })
    }
}
