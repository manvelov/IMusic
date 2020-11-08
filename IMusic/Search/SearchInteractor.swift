//
//  SearchInteractor.swift
//  IMusic
//
//  Created by Kirill Manvelov on 29.07.2020.
//  Copyright (c) 2020 Kirill Manvelov. All rights reserved.
//

import UIKit

protocol SearchBusinessLogic {
  func makeRequest(request: Search.Model.Request.RequestType)
}

class SearchInteractor: SearchBusinessLogic {

  var presenter: SearchPresentationLogic?
  var service: SearchService?
  var networkService = NetworkService()
  
  func makeRequest(request: Search.Model.Request.RequestType) {
    if service == nil {
      service = SearchService()
    }
    
    
    switch request {
    case .getTracks(let seachTerm):
        presenter?.presentData(response: Search.Model.Response.ResponseType.presentFooterView)
        networkService.fetchTrack(searchText: seachTerm) { [weak self] (response) in
            self?.presenter?.presentData(response: Search.Model.Response.ResponseType.presentTracks(searchResponse: response))
        }
    }
  }
}
