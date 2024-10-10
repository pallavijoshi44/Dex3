//
//  PokemonExtension.swift
//  Dex3
//
//  Created by Pallavi Joshi on 10/10/2024.
//

import Foundation

extension Pokemon {
    
    var background : String {
        switch(self.types![0]) {
        case "normal", "grass", "electric", "poison", "fairy" :
            return "normalgrasselectricpoisonfairy"
        case "rock", "ground", "steel", "fighting", "host" , "dark", "psychic":
            return "rockgroundsteelfightingghostdarkpsychic"
        case "fire", "dragon" :
            return "firedragon"
        case "flying", "bug" :
            return "flyingBug"
        case "ice" :
            return "ice"
        case "water" :
            return "water"
        default:
            return "cant reach here"
        }
    }
    
    var stats : [Stat] {
        return [
            Stat(id: 1, label: "HP", value: self.hp),
            Stat(id: 2, label: "Attack", value: self.attack),
            Stat(id: 3, label: "Defense", value: self.defense),
            Stat(id: 4, label: "Special Attack", value: self.specialAttack),
            Stat(id: 5, label: "Special Defense", value: self.specialDefense),
            Stat(id: 6, label: "Speed", value: self.speed),
            
        ]
    }
    
    var highestStat: Stat {
        return stats.max { $0.value < $1.value }!
    }
}


struct Stat : Identifiable {
    let id: Int
    let label: String
    let value: Int16
}
