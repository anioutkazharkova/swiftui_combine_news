//
//  NewsItemView.swift
//  NewsSwiftUI
//
//  Created by 1 on 16.02.2020.
//  Copyright © 2020 azharkova. All rights reserved.
//

import SwiftUI
import Combine

@available(iOS 15.0, *)
struct NewsItemView: View{
    
    @ObservedObject var model: NewsItemModel =  NewsItemModel()
    init(){}
    init(item: NewsItem) {
        self.init()
        self.model.setupData(item: item)
    }
    
    var body: some View {
        GeometryReader { reader in
        ScrollView {
            VStack(alignment: .leading, spacing: 10){
                AsyncImage(url: URL(string: model.data.urlToImage ?? "")) { image in
                    image.resizable(resizingMode: .stretch)
                     } placeholder: {
                             Color.green
                     }.frame(width: reader.size.width - 40, height: 250, alignment: .topLeading)
                Text(model.data.title ?? "").largeTitleStyle()
            Text(model.data.dateString).smallTitleStyle()
            Text(model.data.content ?? "").subtitleStyle()
            Button(action: {
                UIApplication.shared.open(URL(string: self.model.data.url ?? "")!, options: [:], completionHandler: nil)
            }) {
                Text("Show more").smallTitleStyle()
            }
            Spacer()
            }.padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
        }
        .navigationBarTitle(Text(""), displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            self.model.updateFavorite()
        }){
            Image(model.data.favorite ? "favorite" : "unfavorite").frame(width: 20, height: 20, alignment: .topTrailing)
        })
            .fixedSize(horizontal: false, vertical: false).onAppear {
                self.model.setupContent()
        }
    }
    }
}

@available(iOS 15.0, *)
extension NewsItemView: IModelView {
    var viewModel: IModel? {
        get {
            return model
        }
    }
}
