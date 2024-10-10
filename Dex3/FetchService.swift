//
//  FetchPokemonService.swift
//  Dex3
//
//  Created by Pallavi Joshi on 10/10/2024.
//

import Foundation

class FetchService {
    
    enum NetworkError: Error {
        case badUrl
        case badResponse
        case noPokemanResults
    }
    
    let baseUrl = URL(string: "https://pokeapi.co/api/v2/pokemon/")!
    
    func fetchTemporaryPokemon() async throws -> [TempPokemon] {
        var tempPokemons : [TempPokemon] = []

        var fetchUrl = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true)
        fetchUrl?.queryItems = [URLQueryItem(name: "limit", value: "386")]
        
        guard let url = fetchUrl?.url else {
            throw NetworkError.badUrl
        }
        
        var (data, response) =  try await URLSession.shared.data(from: url)
       
        guard let response = response as? HTTPURLResponse, response.statusCode == 200  else {
            throw NetworkError.badResponse
        }
        
        var pokemonDictionary = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        var results = pokemonDictionary?["results"] as? [[String: String]]
        
        guard let results = results, results.isEmpty == false else {
            throw NetworkError.noPokemanResults
        }
        
       
        for pokemon in results {
            if let pokemonUrl = pokemon["url"] {
                tempPokemons.append(try await fetchPokemon(url: URL(string: pokemonUrl)!))
            }
        }
        return tempPokemons
    }
    
    private func fetchPokemon(url: URL) async throws -> TempPokemon {
        var (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200  else {
            throw NetworkError.badResponse
        }
        let tempPokemon = try JSONDecoder().decode(TempPokemon.self, from: data)
        print("id: \(tempPokemon.id) name: \(tempPokemon.name)")
        return tempPokemon
    }
     
}
