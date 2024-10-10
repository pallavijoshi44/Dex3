//
//  PokemonChart.swift
//  Dex3
//
//  Created by Pallavi Joshi on 10/10/2024.
//

import SwiftUI
import Charts

struct PokemonChart: View {
    @EnvironmentObject var pokemon: Pokemon

    var body: some View {
        Chart(pokemon.stats) { stat in
            BarMark(
                x: .value("Value", stat.value),
                y: .value("Label", stat.label)
            )
            .annotation(position:.trailing) {
                Text("\(stat.value)")
                    .padding(.top, -5)
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
                    
                
            }
        }
        .frame(height: 200)
        .padding([.leading,.bottom,.trailing])
        .foregroundColor(Color(pokemon.types![0].capitalized))
        .chartXScale(domain: (0...pokemon.highestStat.value + 5))
    }
}

#Preview {
    PokemonChart().environmentObject(SamplePokemon.samplePokemon)
}
