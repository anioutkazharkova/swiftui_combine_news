//
//  ThumbImage.swift
//  TestNewsSearch
//
//  Created by 1 on 15.02.2020.
//  Copyright © 2020 azharkova. All rights reserved.
//

import Foundation
import SwiftUI

struct ThumbImage : View {
    @ObservedObject var imageModel: ImageLoader
    @State var size: CGFloat = 100
    
    init(withURL url:String) {
        imageModel = ImageLoader(urlString:url)
    }

    var body: some View {
            Image(uiImage:imageModel.image).resizable().aspectRatio(contentMode: .fill).frame(width: size, height: size, alignment: .center).clipped().onAppear {
            imageModel.load()
        }
    }
    
}
