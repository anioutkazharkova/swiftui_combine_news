//
//  SearchModel.swift
//  NewsSwiftUI
//
//  Created by 1 on 16.02.2020.
//  Copyright © 2020 azharkova. All rights reserved.
//

import Foundation
import Combine

@available(iOS 15.0, *)
class SearchModel : ObservableObject,IModel {
    @Published var text: String = ""
    @Published var items:[NewsItem] = [NewsItem]()
    @Published var search:[SearchItem] = [SearchItem]()
    var subscriptions = Set<AnyCancellable>()
    var listener: IContainer?
    
    private weak var newsService: INewsService? = DI.serviceContainer.newsService
    
    private var query = ""
    private let take: Int = 20
    private var page: Int = 0
    private var total: Int = 0
    
    private var retrievedData: [NewsItem] = [NewsItem]()
    private var searchHistory: [SearchItem] = [SearchItem]()
    private var foundResults: [NewsItem] = [NewsItem]()
    
    func loadSearchHistory() {
        newsService?.getRecentRequests { [weak self] results in
            guard let self = self else {return}
            self.searchHistory = results
            self.search = self.searchHistory
        }
    }
    
    func searchWithQuery(query: String) {
        if !query.isEmpty{
            let item = SearchItem(title: query)
            if searchHistory.contains(item) {
                if let index = searchHistory.firstIndex(of: item) {
                    searchHistory.remove(at: index)
                }
            }
            
            newsService?.saveRecentRequests(items: searchHistory)
            if query.count > 2 {
                searchHistory.insert(item, at: 0)
                searchNews(query: query, withRefresh: true)
            } else {
                searchLocal(query: query)
            }
        }
    }
    
    @available(iOS 15.0, *)
    func searchNewsAsync(query: String){
        self.listener?.showLoading()
        Task {
        let result = await self.newsService?.searchNewsAsync(query: query, page: self.page)
        switch (result) {
        case .success(let list):
            self.listener?.hideLoading()
            self.retrievedData.append(contentsOf: list.articles ?? [NewsItem]())
            self.items = list.articles ?? [NewsItem]()
        default:
            break
        }
        }
    }
    
    func searchNews(query: String, withRefresh: Bool) {
        self.listener?.showLoading()
        _ = self.newsService?.searchNews(query: query, page: self.page) .sink(receiveCompletion: { [weak self] completion in
            guard let self = self else {return}
            self.listener?.hideLoading()
            switch completion {
            case .failure(let error):
                self.listener?.showError(error: error.localizedDescription )
                print(error.localizedDescription)
            case .finished:
                print("Success")
            }
        }, receiveValue: { [weak self] (list) in
            guard let self = self else {return}
            self.listener?.hideLoading()
            let results = list.articles ?? [NewsItem]()
            self.retrievedData.append(contentsOf: results)
            self.items = results
            }).store(in: &subscriptions)
    }
    
    private func searchLocal(query: String) {
        self.items = retrievedData.filter {($0.title ?? "").contains(query)}
    }

    
    func update(data: Any?) {
        
    }
}
