//
//  AboutView.swift
//  GameCatalog
//
//  Created by ben on 22/03/25.
//

import SwiftUI
import GameCatalogAbout

struct AboutView: View {
    var body: some View {
        AboutMeView()
    }
}

#Preview {
    NavigationView {
        AboutView()
    }
    .preferredColorScheme(.dark)
}
