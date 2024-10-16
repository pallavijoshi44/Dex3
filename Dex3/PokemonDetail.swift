//
//  PokemonDetail.swift
//  Dex3
//
//  Created by Pallavi Joshi on 10/10/2024.
//

import SwiftUI
import CoreData

struct PokemonDetail: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var pokemon: Pokemon
    @State var shiny: Bool = false
    
    var body: some View {
        ScrollView {
                ZStack {
                    Image(pokemon.background)
                        .resizable()
                        .scaledToFit()
                        .shadow(color: .black, radius: 7)
                    
                    AsyncImage(
                        url: shiny ? pokemon.shiny : pokemon.sprite,
                        content: { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .padding(.top, 50)
                                .shadow(color: .black, radius: 7)
                        },
                        placeholder: {
                            ProgressView()
                            
                        })
                }
                
                HStack {
                    ForEach(pokemon.types!, id: \.self){ type in
                        Text(type.capitalized)
                            .font(.title2)
                            .shadow(color: .white, radius: 1)
                            .padding([.top, .bottom], 7)
                            .padding([.leading, .trailing], 7)
                            .background(Color(type.capitalized))
                            .cornerRadius(50)
                        
                        
                    }
                    Spacer()

                    Button(action: {
                        withAnimation {
                            pokemon.favorite.toggle()
                            do {
                                try viewContext.save()
                            } catch {
                                let nsError = error as NSError
                                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                            }
                        }
                    }, label: {
                        Image(systemName: pokemon.favorite ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                            .font(.title)
                    })
                    
                    
                }.padding()
            
            Text("Stats")
                .font(.title)
                .padding(.bottom, -7)
            
            PokemonChart().environmentObject(pokemon)
        }
        .navigationTitle(pokemon.name!.capitalized)
        .toolbar {
            ToolbarItem(placement:.navigationBarTrailing) {
                Button(action: {
                    shiny.toggle()
                }, label: {
                    if (shiny) {
                        Image(systemName: "wand.and.stars")
                            .foregroundColor(.yellow)
                    } else {
                        Image(systemName: "wand.and.stars.inverse")
                            .foregroundColor(.yellow)
                    }
                })
            }
        }
    }
}



struct PokemonDetail_PreviewProvider: PreviewProvider {
    
    static var previews: some View {
        
        return PokemonDetail()
            .environmentObject(SamplePokemon.samplePokemon)
    }
}
