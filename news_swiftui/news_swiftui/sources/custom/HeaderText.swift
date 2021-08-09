//
//  HeaderText.swift
//  TestNewsSearch
//
//  Created by 1 on 15.02.2020.
//  Copyright © 2020 azharkova. All rights reserved.
//

import Foundation
import SwiftUI


struct HeaderText: View {
    @State var text: String
    
    var body: some View {
        Text(text).font(.system(size: 16)).bold()
    }
}

struct Header: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 16).bold())
    }
}

extension View {
    func titleStyle() -> some View {
        self.modifier(Header())
    }
}
