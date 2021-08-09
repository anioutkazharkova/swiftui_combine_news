//
//  AsyncLoadedImage.swift
//  AsyncLoadedImage
//
//  Created by Anna Zharkova on 07.08.2021.
//

import Foundation
import SwiftUI

struct AsyncLoadedImage<Placeholder: View>: View {
    @ObservedObject private var loader: AsyncImageLoader
    private let placeholder: Placeholder?
    
    init(url: URL, placeholder: Placeholder? = nil) {
        loader = AsyncImageLoader(url: url)
        self.placeholder = placeholder
    }

    var body: some View {
        image
            .onAppear(perform: loader.load)
            .onDisappear(perform: loader.cancel)
    }
    
    private var image: some View {
        placeholder
    }
}
