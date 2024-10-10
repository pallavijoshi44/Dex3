//
//  ViewModel.swift
//  Dex3
//
//  Created by Pallavi Joshi on 10/10/2024.
//

import Foundation

@MainActor
class ViewModel: ObservableObject {
    enum Status {
        case notstarted
        case fetching
        case success
        case error
    }
    
    private let fetchService: FetchService
    
    @Published private(set) var status : Status = Status.notstarted
    
    init(controller: FetchService) {
        self.fetchService = controller
        Task {
            await getPokemons()
        }
    }
    
    private func getPokemons() async {
        status = .fetching
        do {
            var pokemonList = try await fetchService.fetchTemporaryPokemons()
            pokemonList.sort { $0.id < $1.id }
                       
            for tempPokemon in pokemonList {
                let pokemon = Pokemon(context: PersistenceController.preview.container.viewContext)
                pokemon.id = Int16(tempPokemon.id)
                pokemon.name = tempPokemon.name
                pokemon.types = tempPokemon.types
                pokemon.hp = Int16(tempPokemon.hp)
                pokemon.attack = Int16(tempPokemon.attack)
                pokemon.defense = Int16(tempPokemon.defense)
                pokemon.specialAttack = Int16(tempPokemon.specialAttack)
                pokemon.specialDefense = Int16(tempPokemon.specialDefense)
                pokemon.speed = Int16(tempPokemon.speed)
                pokemon.favorite = false
                pokemon.sprite = tempPokemon.sprite
                pokemon.shiny = tempPokemon.shiny
                
                try PersistenceController.preview.container.viewContext.save()
            }
            status = Status.success
        } catch {
            status = Status.error
        }
    }
}
