//
//  JsonHelper.swift
//  news_swiftui
//
//  Created by Anna Zharkova on 13.02.2021.
//

import Foundation

class JsonHelper {
    static let shared = JsonHelper()
    
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yyyy"
        decoder.dateDecodingStrategy = .formatted(df)
        return decoder
    }()
    
    private lazy var encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yyyy"
        encoder.dateEncodingStrategy = .formatted(df)
        return encoder
    }()
    
    func encode<T>(data: T)->String? where T:Codable{
        do {
            let data = try encoder.encode(data)
            return String(data: data, encoding: .utf8)
        }
        catch {
            return nil
        }
    }
    
    func encodeArray<T>(data: [T])->String? where T:Codable{
        do {
            let data = try encoder.encode(data)
            return String(data: data, encoding: .utf8)
        }
        catch {
            return nil
        }
    }
    
    func decode<T:Codable>(json: Data)->T? {
        do {
            return try decoder.decode(T.self, from: json)
        }catch {
            return nil
        }
    }
    
    func decodeArray<T:Codable>(json: Data)->[T]? {
        do {
            return try decoder.decode(Array<T>.self, from: json)
        }catch {
            return nil
        }
    }
    
    func decode<T:Codable>(json: String)->T? {
        do {
            let data =  Data(json.utf8)
            return try decoder.decode(T.self, from: data)
            
        }catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func decodeArray<T:Codable>(json: String)->[T]? {
        do {
            let data =  Data(json.utf8)
            return try decoder.decode(Array<T>.self, from: data)
            
        }catch {
            return nil
        }
    }

}
