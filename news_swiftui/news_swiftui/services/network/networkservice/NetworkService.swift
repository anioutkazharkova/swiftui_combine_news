//
//  NetworkService.swift
//  MoviesSearch
//
//  Created by 1 on 16.02.2019.
//  Copyright © 2019 1. All rights reserved.
//

import Foundation
import Combine

enum Methods {
    case get, post, patch, delete
    
    func toMethod()->String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .patch:
            return "PATCH"
        case .delete:
            return "DELETE"
        }
    }
}

class NetworkService: NSObject, INetworkService {
    let config: INetworkConfiguration = NetworkConfiguration()
    
    var urlConfiguration = URLSessionConfiguration.default
    
    lazy var urlSession: URLSession? = {
        return URLSession(configuration: urlConfiguration)
    }()
    
    var dataTask: URLSessionDataTask? = nil
    
    func request<T:Codable>(url: String, parameters: [String : Any], method: Methods, _ type: T.Type = T.self)->AnyPublisher<T,Error> {
        
        let apiUrl = "\(self.config.getBaseUrl())\(url)"
        
        guard let urlPath = URL(string: apiUrl) else {
            return Result<T, Error>.Publisher(ErrorResponse(type: .network)).eraseToAnyPublisher()
        }
        var urlRequest = URLRequest(url: urlPath)
        urlRequest.httpMethod = method.toMethod()
        
        let headers = self.config.getHeaders()
        
        for header in headers.keys {
            if let value = headers[header] {
                urlRequest.addValue(value, forHTTPHeaderField: header)
            }
        }
        
        let task =  URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap({ (data,response) -> T in
                if let response = response as? HTTPURLResponse {
                    let result = ContentResponse<T>(response: response, data: data)
                    if let content = result.content {
                        return content
                    } else
                    if let er = result.error {
                        throw er
                    }
                }
                throw ErrorResponse(type: .network)
            })
            .mapError({ (error) -> Error in
                return error
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        return task
    }
}
