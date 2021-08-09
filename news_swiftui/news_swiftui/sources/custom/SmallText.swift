//
//  SmallText.swift
//  TestNewsSearch
//
//  Created by 1 on 15.02.2020.
//  Copyright © 2020 azharkova. All rights reserved.
//

import Foundation
import SwiftUI


struct SmallText: View {
    @State var text: String
    
    var body: some View {
          Text(text).font(.system(size: 12))
    }
}

struct SmallTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 12))
    }
}

extension View {
    func smallTitleStyle() -> some View {
        self.modifier(SmallTitle())
    }
}
