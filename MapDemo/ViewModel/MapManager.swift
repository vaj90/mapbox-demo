//
//  MapManager.swift
//  MapDemo
//
//  Created by Allan John Valiente on 2023-05-07.
//

import UIKit
import SwiftUI

class MapManager  {
    private static let _instance = MapManager();
    static var instance: MapManager {
        return _instance
    }
    
    typealias CompletionHandler = (_ response: Data?, _ error:String?) -> ()
    func get(url: String, completion:@escaping(CompletionHandler)) {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, error.localizedDescription)
            }
            if let data = data  {
                completion(data, nil)
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
      }.resume()
    }
    

 
}
