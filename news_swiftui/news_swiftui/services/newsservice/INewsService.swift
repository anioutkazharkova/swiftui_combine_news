//
//  INewsService.swift
//  MoviesSearch
//
//  Created by 1 on 16.02.2019.
//  Copyright © 2019 1. All rights reserved.
//

import Foundation
import  Combine
protocol INewsService: class {
    func getNewsList(page: Int)->AnyPublisher<NewsList,Error> 
    func searchNews(query: String, page: Int)->AnyPublisher<NewsList,Error>
    func getRecentRequests(completion: @escaping([SearchItem]) -> Void)
    func saveRecentRequests(items: [SearchItem])
    func addToFavorite(newsItem: NewsItem)
    func getFavorites() -> [NewsItem]
    func removeFromFavorite(newsItem: NewsItem)
    func syncWithFavorite(loadedNews: [NewsItem]) -> [NewsItem]
}
