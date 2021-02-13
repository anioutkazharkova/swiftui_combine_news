//
//  SearchItem.swift
//  TestNewsSearch
//
//  Created by 1 on 22.02.2019.
//  Copyright © 2019 1. All rights reserved.
//

import Foundation
// MARK: Model for search history item
class SearchItem: Codable,Identifiable {

    var title: String?

    enum CodingKeys: String, CodingKey {
        case title = "title"
    }
    
    init(){}
    convenience init(title: String) {
        self.init()
        self.title = title
    }

}

extension SearchItem: Equatable {
    static func == (lhs: SearchItem, rhs: SearchItem) -> Bool {
        return lhs.title == rhs.title
    }
}
