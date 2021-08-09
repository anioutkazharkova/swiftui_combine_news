//
//  NewsListRow.swift
//  NewsSwiftUI
//
//  Created by 1 on 16.02.2020.
//  Copyright © 2020 azharkova. All rights reserved.
//

import Foundation
import SwiftUI

struct NewsItemRow: View {
    @State var data: NewsItem
    var action: ((String)->Void)
    
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                ZStack {
                    ThumbImage(withURL: data.urlToImage ?? "")
                    Button(action:{
                        self.action(self.data.uuid)
                    }) {Image(self.data.favorite ? "favorite" : "unfavorite").colorMultiply(.white).frame(width: 20, height: 20, alignment: .topTrailing)}.offset(x: 50, y: -50)
                }
                VStack(alignment: .leading,spacing: 0) {
                    Text(data.title ?? "").titleStyle()
                    Text( data.description ?? "").subtitleStyle().lineLimit(4)
                    Text(data.publishedAt?.formatToString("dd.MM.yyyy") ?? "").smallTitleStyle()
                    //HeaderText(text: data.title ?? "").lineLimit(4)
                    //SubheaderText(text: data.description ?? "").lineLimit(4)
                    //SmallText(text: data.publishedAt?.formatToString("dd.MM.yyyy") ?? "")
                }
               
            }
        }
        .background(Color.white)
    }
}
