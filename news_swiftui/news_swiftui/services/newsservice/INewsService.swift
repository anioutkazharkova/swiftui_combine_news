//
//  INewsService.swift
//  MoviesSearch
//
//  Created by 1 on 16.02.2019.
//  Copyright © 2019 1. All rights reserved.
//

import Foundation
import  Combine
@available(iOS 15.0, *)
protocol INewsService: AnyObject {
    func getNewsList(page: Int)->AnyPublisher<NewsList,Error> 
    func searchNews(query: String, page: Int)->AnyPublisher<NewsList,Error>
    func getRecentRequests(completion: @escaping([SearchItem]) -> Void)
    func saveRecentRequests(items: [SearchItem])
    func addToFavorite(newsItem: NewsItem)
    func getFavorites() -> [NewsItem]
    func removeFromFavorite(newsItem: NewsItem)
    func syncWithFavorite(loadedNews: [NewsItem]) -> [NewsItem]
    
    func searchNewsAsync(query: String, page: Int) async -> Result<NewsList,Error>
    func searchNewsAsync2(query: String, page: Int) async -> Result<NewsList,Error>
    func searchNewsAsync3(query: String, page: Int) async -> Result<NewsList,Error>
}
