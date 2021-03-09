//
//  ShimmerMoveRow.swift
//  Pokedex
//
//  Created by Marlon David Ruiz Arroyave on 8/03/21.
//

import SwiftUI

struct ShimmerMoveRow: View {
    @State var show = false
    var center = (UIScreen.main.bounds.width / 2) + 110

    var body: some View {
        ZStack {
            HStack() {
                Rectangle()
                    .fill(Color.black.opacity(0.09))
                    .frame(width: 200, height: 20)
                Spacer()
                Circle()
                    .fill(Color.black.opacity(0.09))
                    .frame(width: 30, height: 30)

            }
            .padding(.horizontal, 20.0)

            HStack() {
                Rectangle()
                    .fill(Color.black.opacity(0.09))
                    .frame(width: 200, height: 20)
                Spacer()
                Circle()
                    .fill(Color.black.opacity(0.09))
                    .frame(width: 30, height: 30)

            }
            .padding(.horizontal, 20.0)
            .mask(
                Rectangle()
                    .fill(
                        LinearGradient(gradient: .init(colors: [.clear, Color.white.opacity(0.60), .clear]), startPoint: .top, endPoint: .bottom)
                    )
                    .rotationEffect(.init(degrees: 70))
                    .offset(x: show ? center : -center)
            )
        }
    }
}

struct ShimmerMoveRow_Previews: PreviewProvider {
    static var previews: some View {
        ShimmerMoveRow()
    }
}
