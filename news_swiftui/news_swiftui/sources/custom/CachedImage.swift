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
    @ObservedObject var imageModel: ImageModel
    @State var image:UIImage = UIImage()
    
    init(withURL url:String) {
        imageModel = ImageModel(urlString:url)
    }
    
    var body: some View {
        
        Image(uiImage:imageModel.image ?? image).resizable().aspectRatio(contentMode: .fill)
    }
    
}
