//
//  NetworkService.swift
//  IMusic
//
//  Created by Kirill Manvelov on 29.07.2020.
//  Copyright © 2020 Kirill Manvelov. All rights reserved.
//

import UIKit
import Alamofire

class NetworkService {
    
    func fetchTrack(searchText: String, complition: @escaping(SearchResponse?)->Void) {
       
        let url = "https://itunes.apple.com/search"
        let parameters = [
            "term": "\(searchText)",
            "limit": "10",
            "media": "music"
            ]
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseData { (responseData) in
            
            if let error = responseData.error {
                print("Error occured: \(error)")
                complition(nil)
                return
            }
                                  
            guard let data = responseData.data else { return }
            let decoder = JSONDecoder()
            do {
                let objects = try decoder.decode(SearchResponse.self, from: data)
                complition(objects)
                
            } catch let jsonError {
                print("Failed to decode response:", jsonError)
                complition(nil)
                
            }
        }
        
    }
    
}
