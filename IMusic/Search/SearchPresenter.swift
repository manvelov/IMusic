//
//  SearchPresenter.swift
//  IMusic
//
//  Created by Kirill Manvelov on 29.07.2020.
//  Copyright (c) 2020 Kirill Manvelov. All rights reserved.
//

import UIKit

protocol SearchPresentationLogic {
  func presentData(response: Search.Model.Response.ResponseType)
}

class SearchPresenter: SearchPresentationLogic {
  weak var viewController: SearchDisplayLogic?
  
  func presentData(response: Search.Model.Response.ResponseType) {
    switch response {
    case .presentTracks(searchResponse: let searchResponse):
        let cells = searchResponse?.results.map({ (track) in
            cellViewModell(from: track)
        }) ?? []
        let searchViewModel = SearchViewModel.init(cells: cells)
        viewController?.displayData(viewModel: Search.Model.ViewModel.ViewModelData.displayCells(searchViewModel: searchViewModel))
    case .presentFooterView:
        viewController?.displayData(viewModel: Search.Model.ViewModel.ViewModelData.displayFooterView)
    }
  
    }

    private func cellViewModell(from track: Track) -> SearchViewModel.Cell {
        return SearchViewModel.Cell.init(iconUrlString: track.artworkUrl100,
                                         trackName: track.trackName,
                                         artistName: track.artistName,
                                         collectionName: track.collectionName ?? "",
                                         previewUrl: track.previewUrl)
    }
    
}

