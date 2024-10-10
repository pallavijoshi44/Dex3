//
//  TempPokemonModel.swift
//  Dex3
//
//  Created by Pallavi Joshi on 09/10/2024.
//

import Foundation

struct TempPokemon: Codable {
    let id: Int
    let name: String
    let types : [String]
    var hp : Int = 0
    var attack : Int = 0
    var defense : Int = 0
    var specialAttack : Int = 0
    var specialDefense : Int = 0
    var speed : Int = 0
    let sprite : URL
    let shiny : URL
    let favorite : Bool = false

    enum PokemonKeys: String, CodingKey {
        case id
        case name
        case types
        case stats
        case sprites
        
        enum TypesDictionaryKeys: String, CodingKey {
            case type
            
            enum TypeKeys: String, CodingKey {
                case name
            }
        }
        
        enum StatsDictionaryKeys: String, CodingKey {
            case value = "base_stat"
            case stat
            
            enum StatKeys: String, CodingKey {
                case name
            }
        }
        
        enum SpriteDictionaryKeys: String, CodingKey {
            case sprite = "front_default"
            case shiny = "front_shiny"
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PokemonKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        
        var decodedTypes: [String] = []
        var typesContainer = try container.nestedUnkeyedContainer(forKey: .types)
        while typesContainer.isAtEnd {
            var typeDictionaryContainer = try typesContainer.nestedContainer(keyedBy: PokemonKeys.TypesDictionaryKeys.self)
            var typeContainer = try typeDictionaryContainer.nestedContainer(keyedBy: PokemonKeys.TypesDictionaryKeys.TypeKeys.self, forKey: .type)
            let typeValue: String = try typeContainer.decode(String.self, forKey: .name)
            decodedTypes.append(typeValue)
        }
        types = decodedTypes
        
        var statsContainer = try container.nestedUnkeyedContainer(forKey: .stats)
        while statsContainer.isAtEnd {
            var statsDictionaryContainer = try statsContainer.nestedContainer(keyedBy: PokemonKeys.StatsDictionaryKeys.self)
            var statsContainer = try statsDictionaryContainer.nestedContainer(keyedBy: PokemonKeys.StatsDictionaryKeys.StatKeys.self, forKey: .stat)
            var statName = try statsContainer.decode(String.self, forKey: .name)
            
            switch statName {
            case "hp": 
                hp = try statsDictionaryContainer.decode(Int.self, forKey: .value);
            case "attack":
                attack = try statsDictionaryContainer.decode(Int.self, forKey: .value);
            case "defense":
                defense = try statsDictionaryContainer.decode(Int.self, forKey: .value);
            case "specialAttack":
                specialAttack = try statsDictionaryContainer.decode(Int.self, forKey: .value);
            case "specialDefense":
                specialDefense = try statsDictionaryContainer.decode(Int.self, forKey: .value);
            case "speed":
                speed = try statsDictionaryContainer.decode(Int.self, forKey: .value);
            
            default:
                print("it wont reach here")
            
            }
        }
        
        var spriteContainer =  try container.nestedContainer(keyedBy: PokemonKeys.SpriteDictionaryKeys.self, forKey: .sprites)
        shiny = try spriteContainer.decode(URL.self, forKey: .shiny)
        sprite = try spriteContainer.decode(URL.self, forKey: .sprite)
    }
}
