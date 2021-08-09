//
//  CachedImage.swift
//  NewsSwiftUI
//
//  Created by 1 on 16.02.2020.
//  Copyright © 2020 azharkova. All rights reserved.
//

import Foundation
import SwiftUI

struct CachedImage : View {
    @ObservedObject var imageModel: ImageLoader
    @State var size: CGFloat = 100
    
    init(withURL url:String) {
        imageModel = ImageLoader(urlString:url)
    }
    
    var body: some View {
        Image(uiImage:imageModel.image).resizable().scaledToFill().onAppear {
            imageModel.load()
        }
    }
}
