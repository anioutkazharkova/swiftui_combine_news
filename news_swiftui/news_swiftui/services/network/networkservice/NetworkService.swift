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
    
    @available(iOS 15.0, *)
    func requestAsync<T:Codable>(url: String, parameters: [String : Any], method: Methods, _ type: T.Type = T.self) async -> Result<T,Error> {
        let apiUrl = "\(self.config.getBaseUrl())\(url)"
        guard let urlPath = URL(string: apiUrl) else {
            return Result<T, Error>.failure(ErrorResponse(type: .network))
        }
            var urlRequest = URLRequest(url: urlPath)
            urlRequest.httpMethod = method.toMethod()
            
            let headers = self.config.getHeaders()
            
            for header in headers.keys {
                if let value = headers[header] {
                    urlRequest.addValue(value, forHTTPHeaderField: header)
                }
            }
        do {
            let task = try await URLSession.shared.data(for: urlRequest)
            let data = task.0
            let response = task.1
            if let response = response as? HTTPURLResponse {
                let result = ContentResponse<T>(response: response, data: data)
                if let content = result.content {
                    return Result.success(content)
                } else {
                    return Result<T,Error>.failure(result.error ?? ErrorResponse(type: .other))
                }
            }
            return Result<T, Error>.failure(ErrorResponse(type: .network))
        }catch {
            return Result<T,Error>.failure(error)
        }
        
    }
    
    func requestSimple<T:Codable>(url: String, parameters: [String : Any], method: Methods, _ type: T.Type = T.self, _ completion: @escaping(Result<T,Error>)->Void) {
        let apiUrl = "\(self.config.getBaseUrl())\(url)"
        guard let urlPath = URL(string: apiUrl) else {
            return
        }
            var urlRequest = URLRequest(url: urlPath)
            urlRequest.httpMethod = method.toMethod()
            
            let headers = self.config.getHeaders()
            
            for header in headers.keys {
                if let value = headers[header] {
                    urlRequest.addValue(value, forHTTPHeaderField: header)
                }
            }
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let data = data, let response = response as? HTTPURLResponse {
                let result = ContentResponse<T>(response: response, data: data)
                if let content = result.content {
                    DispatchQueue.main.async {
                        
                    completion(Result.success(content))
                    }
                } else {
                    DispatchQueue.main.async {
                    completion(Result<T,Error>.failure(result.error ?? ErrorResponse(type: .other)))
                    }
                }
            } else {
                DispatchQueue.main.async {
                completion(Result<T, Error>.failure(ErrorResponse(type: .network)))
                }
            }
        }
        dataTask.resume()
    }
    
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

extension Publishers {
    struct MissingOutputError: Error {}
}

extension Publisher {
    @available(iOS 15.0, *)
    func singleResult() async throws -> Output {
        var cancellable: AnyCancellable?
        var didReceiveValue = false

        return try await withCheckedThrowingContinuation { continuation in
            cancellable = sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    case .finished:
                        if !didReceiveValue {
                            continuation.resume(
                                throwing: Publishers.MissingOutputError()
                            )
                        }
                    }
                },
                receiveValue: { value in
                    guard !didReceiveValue else { return }

                    didReceiveValue = true
                    cancellable?.cancel()
                    continuation.resume(returning: value)
                }
            )
        }
    }
}
