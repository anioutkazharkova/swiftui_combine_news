//
//  LargeText.swift
//  NewsSwiftUI
//
//  Created by 1 on 16.02.2020.
//  Copyright © 2020 azharkova. All rights reserved.
//

import SwiftUI

struct LargeText: View {
    @State var text: String
       
       var body: some View {
             Text(text).font(.system(size: 22)).bold()
       }
}

struct LargeTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 22).bold())
    }
}

extension View {
    func largeTitleStyle() -> some View {
        self.modifier(LargeTitle())
    }
}
