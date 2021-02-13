//
//  NewsList.swift
//  MoviesSearch
//
//  Created by 1 on 17.02.2019.
//  Copyright © 2019 1. All rights reserved.
//

import UIKit

// MARK: Model for news list
class NewsList: Codable,Identifiable {
    var status: String?
    var total: Int = 0
    var articles: [NewsItem]?

    enum CodingKeys : String, CodingKey {
        case total = "totalResults"
        case articles = "articles"
        case status = "status"
    }

}
