//
//  SamplePokemon.swift
//  Dex3
//
//  Created by Pallavi Joshi on 10/10/2024.
//

import Foundation

struct SamplePokemon {
    static let samplePokemon = {
        let viewContext = PersistenceController.preview.container.viewContext
        let request = Pokemon.fetchRequest()
        request.fetchLimit = 1
        let results = try! viewContext.fetch(request)
        return results.first!
    }()
}
