//
//  Main.swift
//  Pokedex
//
//  Created by Marlon David Ruiz Arroyave on 6/03/21.
//

import SwiftUI

enum TabItem: String {
    case pokemon = "Pokemon"
    case moves = "Moves"
    case itens = "Itens"
}

struct Main: View {
    @State var selected: TabItem = .pokemon
    @State var showTabBar: Bool = true
    private var edges = UIApplication.shared.windows.first?.safeAreaInsets

    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { _ in
                ZStack {
                    // Tabs
                    PokemonView(showTabBar: $showTabBar)
                        .opacity(selected == .pokemon ? 1 : 0)

                    MovesView()
                        .opacity(selected == .moves ? 1 : 0)

                    ItensView()
                        .opacity(selected == .itens ? 1 : 0)
                }
            }
            if showTabBar {
                CustomTabView(selected: $selected)
            }
        }
        .ignoresSafeArea(.all, edges: .bottom)
        .background(Color.black.opacity(0.06).ignoresSafeArea(.all, edges: .all))
    }
}

class TabBarSettings: ObservableObject {
    @Published var showTabBar: Bool = true
}

struct CustomTabView: View {
    @Binding var selected: TabItem
    var tabs: [TabItem] = [.pokemon, .moves, .itens]
    var edges: UIEdgeInsets?
    @Namespace var animation

    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.self) { tab in
                TabButton(title: tab, selected: $selected, animation: animation)

                if tab != tabs.last {
                    Spacer(minLength: 0)
                }
            }
        }
        .padding(.horizontal, 30)
        // iphone like 8 and SE
        .padding(.bottom, edges?.bottom == 0 ? 15 : edges?.bottom)
        .background(Color.white)
    }
}

struct TabButton: View {
    var title: TabItem
    @Binding var selected: TabItem
    var animation: Namespace.ID

    var body: some View {
        Button(action: {
            withAnimation { selected = title }
        }) {
            VStack(spacing: 6) {
                // Top Indicator - Custom shape - Slide in and out animation
                ZStack {
                    CustomShape()
                        .fill(Color.clear)
                        .frame(width: 45, height: 6)

                    if selected == title {
                        CustomShape()
                            .fill(Color.green)
                            .frame(width: 45, height: 6)
                            .matchedGeometryEffect(id: "tabChange", in: animation)
                    }
                }
                .padding(.bottom, 10)

                Image(title.rawValue)
                    .renderingMode(.template)
                    .resizable()
                    .foregroundColor(selected == title ? Color(.green) : Color.black.opacity(0.2))
                    .frame(width: 24, height: 24)

                Text(title.rawValue)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(Color.black.opacity(selected == title ? 0.6 : 0.2))
            }
        }
    }
}

// Custom shape

struct CustomShape: Shape {

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 10, height: 10))
        return Path(path.cgPath)
    }
}

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        Main()
    }
}
