//
//  INetworkService.swift
//  MoviesSearch
//
//  Created by 1 on 16.02.2019.
//  Copyright © 2019 1. All rights reserved.
//

import Foundation
import Combine

protocol INetworkService: class {
    func request<T:Codable>(url: String, parameters: [String : Any], method: Methods, _ type: T.Type)->AnyPublisher<T,Error>
}
