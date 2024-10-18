//
//  ContentView.swift
//  Dex3
//
//  Created by Pallavi Joshi on 09/10/2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
        animation: .default)
    private var pokemons: FetchedResults<Pokemon>
    
    @StateObject
    private var pokemonVm =  ViewModel(controller: FetchService())
    
    @State
    private var filterByFavorites: Bool = true
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
        predicate: NSPredicate(format: "favorite = %d", true),
        animation: .default
    )
    private var favorites: FetchedResults<Pokemon>
    
    
    var body: some View {
                switch(pokemonVm.status) {
        
                case .success :
        NavigationStack {
            List(filterByFavorites ? favorites : pokemons) { pokemon in
                NavigationLink(value: pokemon) {
                    AsyncImage(url: pokemon.shiny, content: { image in
                        image.resizable().scaledToFit()
                    }, placeholder: {
                        ProgressView()
                    }).frame(width: 100, height: 100)
                    
                    Text(pokemon.name!)
                    if (filterByFavorites) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        
                    }
                }
            }
            .navigationTitle("PokeDex")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        withAnimation {
                            filterByFavorites.toggle()
                        }
                    } label: {
                        Image(systemName: filterByFavorites ? "star.fill" : "star")
                        
                    }
                    .font(.title)
                    .foregroundColor(.yellow)
                }
            }
            .navigationDestination(for: Pokemon.self, destination: { pokemon in
                PokemonDetail().environmentObject(pokemon)
            })
        }
                default :
                    ProgressView()
                }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
