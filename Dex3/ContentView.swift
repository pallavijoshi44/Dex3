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

    var body: some View {
        NavigationStack{
            List(pokemons) { pokemon in
                NavigationLink(value: pokemon) {
                    AsyncImage(url: pokemon.shiny, content: { image in
                        image.resizable().scaledToFit()
                    }, placeholder: {
                        ProgressView()
                    }).frame(width: 100, height: 100)
                    
                    Text(pokemon.name!)
                }
            }
            .navigationTitle("PokeDex")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            .navigationDestination(for: Pokemon.self, destination: { pokemon in
                AsyncImage(url: pokemon.shiny, content: { image in
                    image.resizable().scaledToFit()
                }, placeholder: {
                    ProgressView()
                }).frame(width: 100, height: 100)
                
                Text(pokemon.name!)
            })
           
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
