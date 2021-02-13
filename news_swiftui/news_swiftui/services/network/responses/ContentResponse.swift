//
//  ContentResponse.swift
//  MoviesSearch
//
//  Created by 1 on 16.02.2019.
//  Copyright © 2019 1. All rights reserved.
//

import Foundation

enum ErrorType {
    case other, network, service
}

class ContentResponse<T: Codable>: NSObject {
    var content: T?
    var error: ErrorResponse? = nil
    var code: Int = 0
    
    override init() {
        super.init()
    }
    
    convenience init(response: HTTPURLResponse?, data: Data) {
        self.init()
        code = response?.statusCode ?? 0
        let string = String(data: data, encoding: .utf8)
        print(string)
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'hh:mm:ss'Z'"
        jsonDecoder.dateDecodingStrategy = .formatted(df)
        if code >= 200 && code < 400 {
        do {
            let result = try jsonDecoder.decode(T.self, from: data)
            content = result
            
            print(content)
        }catch {
            print("\(error)")
        }
        }else {
        
        do {
            self.error = try jsonDecoder.decode(ErrorResponse.self, from: data)
            self.error?.code = code
            print(error)
        }catch {
            print("\(error)")
        }
        }
    }
    
    convenience init(error: ErrorResponse){
        self.init()
        self.error = error
    }
}
