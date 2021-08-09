//
//  ImageLoader.swift
//  NewsSwiftUI
//
//  Created by 1 on 16.02.2020.
//  Copyright © 2020 azharkova. All rights reserved.
//

import Foundation
import SwiftUI
import Combine



class ImageLoader: ObservableObject {
    @Published var image: UIImage = UIImage()
    private var url: String = ""

    init(urlString:String) {
        self.url = urlString
    }
    
    func load() {
        ImageManager.sharedInstance.receiveImage(forKey: url) { (im) in
            DispatchQueue.main.async {
                self.image = im
            }
        }
    }
}
