//
//  ActivityIndicator.swift
//  ActivityIndicator
//
//  Created by Anna Zharkova on 07.08.2021.
//

import SwiftUI

struct LoaderIndicator: View {
    let style = StrokeStyle(lineWidth: 6, lineCap: .round)
    @State var animate = false
    let color = Color.gray
    
    var body: some View {
        ZStack {
            Circle().trim(from: 0, to: 0.2)
                .stroke(AngularGradient(gradient: .init(colors: [color]), center: .center),style: style).rotationEffect(Angle.degrees( animate ? 360 : 0)).animation(Animation.linear(duration: 0.7).repeatForever(autoreverses: false))
            Circle().trim(from: 0.5, to: 0.7)
                .stroke(AngularGradient(gradient: .init(colors: [color]), center: .center),style: style).rotationEffect(Angle.degrees( animate ? 360 : 0)).animation(Animation.linear(duration: 0.7).repeatForever(autoreverses: false))
        }.frame(width: 50, height: 50, alignment: .center).onAppear{
            self.animate.toggle()
        }
    }
}

struct LoaderIndicator_Previews: PreviewProvider {
    static var previews: some View {
       LoaderIndicator()
    }
}
