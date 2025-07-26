//
//  ContentView.swift
//  Dex3
//
//  Created by Rafael Almeida on 1/16/24.
//

import CoreData
import SwiftUI

struct ContentView: View {
  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(
      keyPath: \Pokemon.id,
      ascending: true
    )],
    animation: .default
  )
  private var pokedex: FetchedResults<Pokemon>

  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(
      keyPath: \Pokemon.id,
      ascending: true
    )],
    predicate: NSPredicate(format: "favorite = %d", true),
    animation: .default
  ) private var favorites: FetchedResults<Pokemon>

  @State var filterByFavorites = false
  @StateObject private var pokemonViewModel =
    PokemonViewModel(controller: FetchController())

  var body: some View {
    switch pokemonViewModel.status {
    case .success:
      NavigationStack {
        List(filterByFavorites ? favorites : pokedex) { pokemon in
          NavigationLink(value: pokemon) {
            AsyncImage(url: pokemon.sprite) { image in
              image.resizable().scaledToFit()
            } placeholder: {
              ProgressView()
            }.frame(width: 100, height: 100)

            Text("\(pokemon.name!.capitalized)")

            if pokemon.favorite {
              Spacer()
              Image(systemName: "star.fill")
                .foregroundColor(.yellow)
            }
          }
        }.navigationTitle("Pokedex")
          .navigationDestination(for: Pokemon.self, destination: { pokemon in
            PokemonDetail().environmentObject(pokemon)
          })
          .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
              // button with a star inside it
              Button {
                withAnimation {
                  filterByFavorites.toggle()
                }
              } label: {
                if filterByFavorites {
                  Image(systemName: "star.fill")
                } else {
                  Image(systemName: "star")
                }
              }.font(.title).foregroundColor(.yellow)
            }
          }
      }
    default:
      ProgressView()
    }
  }
}

#Preview {
  ContentView().environment(
    \.managedObjectContext,
    PersistenceController.preview.container.viewContext
  )
}
