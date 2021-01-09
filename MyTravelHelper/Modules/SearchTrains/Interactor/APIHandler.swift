//
//  APIHandler.swift
//  MyTravelHelper
//
//  Created by Vijeesh on 09/01/21.
//  Copyright © 2021 Sample. All rights reserved.
//

import Foundation

final public class APIHandler {
    private init() {}
    public static let sharedInstane = APIHandler()
    
    public func request(url: String, with completion: @escaping (Data?,Error?) -> Void) {
        guard let url = URL(string: url) else {return}
        URLSession.shared.dataTask(with: url) { data, _, error in
            completion(data, error)
        }.resume()
    }
}

