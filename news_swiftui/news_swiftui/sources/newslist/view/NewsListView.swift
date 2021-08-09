//
//  NewsListView.swift
//  NewsSwiftUI
//
//  Created by 1 on 16.02.2020.
//  Copyright © 2020 azharkova. All rights reserved.
//

import SwiftUI
import Combine

@available(iOS 15.0, *)
struct NewsListView: View{
    @State var isSearchActive: Bool  = false
    @State var items = MockHelper.shared.mockItems
    @ObservedObject var model: NewsListModel =  NewsListModel()
    
    init(){}
    
    var body: some View {
        NavigationView{
            /*ScrollView {
            LazyVGrid(columns: [GridItem(.flexible(minimum: 200), spacing: 0),]) {
                ForEach(model.data) {
                    item in
                       NavigationLink(destination:
                        ContainerView(content: NewsItemView(item:item))) {
                        NewsItemRow(data: item,action: {id in
                            self.model.updateFavorite(id: id)
                        })
                        }
            }
            }*/
           /*ScrollView {
                LazyVStack {
                    ForEach(model.data) {
                        item in
                            NavigationLink(destination:
                            ContainerView(content: NewsItemView(item:item))) {
                            NewsItemRow(data: item,action: {id in
                                self.model.updateFavorite(id: id)
                            })
                            }
                }
            }*/
        List(items) { item in
            NavigationLink(destination:
            ContainerView(content: NewsItemView(item:item))) {
            NewsItemRow(data: item,action: {id in
               // self.model.updateFavorite(id: id)
            })
            }
        }.refreshable {
           // self.model.getNews(withRefresh: true)
        }.navigationBarTitle("News", displayMode: .inline)
            .navigationBarItems(trailing: NavigationLink(destination: ContainerView(content:SearchView(isActive: self.$isSearchActive)),isActive: self.$isSearchActive){
                Image("search").resizable().frame(width: 20, height: 20, alignment: .topTrailing)
            })
            .onAppear {
             //   self.model.getNews(withRefresh: true)
        }
        }
    }
}

@available(iOS 15.0, *)
extension NewsListView:IModelView {
    var viewModel: IModel? {
        return model
    }
}
