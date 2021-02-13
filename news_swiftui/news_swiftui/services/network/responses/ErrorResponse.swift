//
//  ErrorResponse.swift
//  MoviesSearch
//
//  Created by 1 on 16.02.2019.
//  Copyright © 2019 1. All rights reserved.
//

import UIKit
import ObjectMapper

class ErrorResponse: NSObject, Codable, Error {
    var code: Int? = 0
    var status: String? = ""
    var message: String? = ""
    var type: ErrorType = .other
    
    override init() {
        super.init()
    }
    
    convenience init(type: ErrorType){
        self.init()
        self.type = type
    }
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case status = "status"
        case message = "message"
    }
}


