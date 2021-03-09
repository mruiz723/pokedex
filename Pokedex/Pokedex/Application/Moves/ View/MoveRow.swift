//
//  MoveRow.swift
//  Pokedex
//
//  Created by Marlon David Ruiz Arroyave on 7/03/21.
//

import SwiftUI
import PokemonAPI

struct MoveRow: View {
    let move: PKMMove?

    var body: some View {
        HStack {
            Text(move?.name?.capitalized ?? "")
                .font(.title3)
                .fontWeight(.light)
            Spacer()
            Image(move?.type?.name?.capitalized ?? "")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .cornerRadius(40/2)
        }
        .padding(.horizontal, 20)
    }
}

struct MoveRow_Previews: PreviewProvider {
    static var previews: some View {
        MoveRow(move: PKMMove.moveMock())
    }
}
