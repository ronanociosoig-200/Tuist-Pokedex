//
//  ContentView.swift
//  PokedexWatchApp
//
//  Created by ronan.ociosoig on 22/04/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image("Ball")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.accentColor)
            Text("Pokedex")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
