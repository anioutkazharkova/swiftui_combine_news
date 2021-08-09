//
//  news_swiftuiApp.swift
//  news_swiftui
//
//  Created by Anna Zharkova on 13.02.2021.
//

import SwiftUI

@available(iOS 15.0, *)
@main
struct news_swiftuiApp: App {
    var body: some Scene {
        WindowGroup {
            ContainerView(content: NewsListView())
        }
    }
}
