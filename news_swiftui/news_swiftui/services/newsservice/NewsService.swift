//
//  NewsService.swift
//  MoviesSearch
//
//  Created by 1 on 16.02.2019.
//  Copyright © 2019 1. All rights reserved.
//

import UIKit
import Combine

class NewsService: INewsService {

    private let networkService: INetworkService
    private let favoriteDao: IFavoriteProvider
    private let searchDao: ISearchProvider
    
    var subscriptions = Set<AnyCancellable>()

    @available(iOS 15.0, *)
    init(networkService: INetworkService) {
        self.networkService = networkService
        self.favoriteDao = DI.dataContainer.favoriteDao
        self.searchDao = DI.dataContainer.searchDao
    }

    // MARK: News request
    func getNewsList(page: Int)->AnyPublisher<NewsList,Error> {

     let parameters = ["page": "\(page)"]
        
        return self.networkService.request(url: Requests.top.value, parameters: parameters, method: .get, NewsList.self)
    }

    // MARK: Sync received data with cached favorite
    func syncWithFavorite(loadedNews: [NewsItem]) -> [NewsItem] {
        let favorite = getFavorites()
        if favorite.count > 0 {
            for var n in loadedNews {
                if let _ = favorite.firstIndex(of: n) {
                    n.favorite = true
                }
            }
        }
        return loadedNews
    }

    // MARK: Favorite

    func getFavorites() -> [NewsItem] {
        return favoriteDao.getFavorites() ?? [NewsItem]()
    }

    func addToFavorite(newsItem: NewsItem) {
        favoriteDao.addFavorite(item: newsItem)
    }

    func removeFromFavorite(newsItem: NewsItem) {
        favoriteDao.removeFavorite(item: newsItem)
    }

    // MARK: Search

    func searchNews(query: String, page: Int = 0)->AnyPublisher<NewsList,Error> {
        networkService.request(url: Requests.everything(query: query).value, parameters: [:], method: Methods.get, NewsList.self)
            .flatMap({ (list) -> AnyPublisher<NewsList,Error> in
                return self.sync(data: list)
            }).eraseToAnyPublisher()
    }
    
    @available(iOS 15.0, *)
    func searchNewsAsync(query: String, page: Int = 0) async -> Result<NewsList,Error>  {
        do {
            let newsData = try await networkService.request(url: Requests.everything(query: query).value, parameters: [:], method: Methods.get, NewsList.self)
            .flatMap({ (list) -> AnyPublisher<NewsList,Error> in
                return self.sync(data: list)
            }).eraseToAnyPublisher().singleResult()
        
            return Result.success(newsData)
        }catch {
            return Result.failure(error)
        }
    }
    
    @available(iOS 15.0, *)
    func searchNewsAsync2(query: String, page: Int = 0) async -> Result<NewsList,Error>  {
        
            let newsData = await networkService.requestAsync(url: Requests.everything(query: query).value, parameters: [:], method: Methods.get, NewsList.self)
        return newsData
    }
    
    @available(iOS 15.0, *)
    func searchNewsAsync3(query: String, page: Int = 0) async -> Result<NewsList,Error>  {
        do {
            let result = try await withCheckedThrowingContinuation({ (continuation: CheckedContinuation<NewsList,Error>) in
            networkService.requestSimple(url: Requests.everything(query: query).value, parameters: [:], method: Methods.get, NewsList.self) { (result: Result<NewsList,Error>) in
                switch result {
                case .success(let data):
                    continuation.resume(with: result)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
                
            }
        })
            return Result.success(result)
        }catch {
            return Result.failure(error)
        }
    }
    
    private func sync(data: NewsList? = nil,_ error: Error? = nil) -> AnyPublisher<NewsList,Error> {
        return Deferred {
            Future { [weak self] promise in
                guard let self = self else {return}
                if let error = error {
                    promise(.failure(error))
                }
                if let data = data, let items = data.articles {
                    let processed = self.syncWithFavorite(loadedNews: items)
                    data.articles = processed
                    promise(.success(data))
                }
            }
        }.eraseToAnyPublisher()
        
        
    }

    func getRecentRequests(completion: @escaping ([SearchItem]) -> Void) {
      let saved =  searchDao.getHistory()
        completion(saved)
    }

    func saveRecentRequests(items: [SearchItem]) {
        searchDao.saveHistory(item: items)
    }

}
