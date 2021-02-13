//
//  CachedObject.swift
//  TestNewsSearch
//
//  Created by 1 on 21.02.2019.
//  Copyright © 2019 1. All rights reserved.
//

import UIKit
import RealmSwift

// MARK: Data structure to store serialized data in storage
class CachedItem: Object {
    @objc dynamic var id = 0
    @objc dynamic var value = ""
    @objc dynamic var tableKey = ""

    override static func primaryKey() -> String? {
        return "id"
    }
}

// MARK: Deserialization
extension CachedItem {
    static func create<T: Codable>(item: T, key: String) -> CachedItem {
        let c = CachedItem()
        c.tableKey = key
        c.value = JsonHelper.shared.encode(data: item) ?? ""
        return c
    }

    func uncache<T: Codable>() -> T? {
        return JsonHelper.shared.decode(json: self.value)
    }

    static func create<T: Codable>(items: [T], key: String) -> CachedItem {
        let c = CachedItem()
        c.tableKey = key
        c.value = JsonHelper.shared.encodeArray(data: items) ?? ""
        return c
    }

    func uncacheArray<T: Codable>() -> [T]? {
        return JsonHelper.shared.decodeArray(json: self.value)
    }
}

// MARK: Deserialization in array
extension Array where Element: CachedItem {
    func uncacheAll<T: Codable>() -> [T]? {
        var data: [T]? = [T]()
        for var r in self {
            data?.append(contentsOf: r.uncacheArray() ?? [T]())
        }
        return data
    }
}
