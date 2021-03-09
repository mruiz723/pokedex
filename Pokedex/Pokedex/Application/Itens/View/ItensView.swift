//
//  ItensView.swift
//  Pokedex
//
//  Created by Marlon David Ruiz Arroyave on 27/02/21.
//

import SwiftUI

struct ItensView: View {
    @Binding var selectedTab: TabItem

    var body: some View {
        NavigationView {
            Text("Itens View")
                .navigationTitle("Itens")
        }
    }
}

struct ItensView_Previews: PreviewProvider {
    static var previews: some View {
        ItensView(selectedTab: .constant(.itens))
    }
}
