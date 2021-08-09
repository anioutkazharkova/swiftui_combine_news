//
//  AsyncImageLoader.swift
//  AsyncImageLoader
//
//  Created by Anna Zharkova on 07.08.2021.
//

import Foundation
import SwiftUI
import Combine
import Foundation

class AsyncImageLoader: ObservableObject {
    @Published var image: UIImage?
    
    private var cancellable: AnyCancellable?
    private let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    func load() {
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
    }
    
    func cancel() {
        cancellable?.cancel()
    }
}
