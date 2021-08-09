//
//  Requests.swift
//  TestNewsSearch
//
//  Created by 1 on 19.02.2019.
//  Copyright © 2019 1. All rights reserved.
//

import Foundation

enum Requests {
    
    case everything(query: String)
    case top
    
    var value: String {
        switch self {
        case .everything(let query):
            return  "everything?q=\(query)&from=2021-08-06&to=2021-08-06&sortBy=popularity"
        case .top:
            return "top-headlines?language=en"
        }
    }
}
