//
//  Stats.swift
//  Dex3
//
//  Created by Rafael Almeida on 1/18/24.
//

import Charts
import SwiftUI

struct Stats: View {
  @EnvironmentObject var pokemon: Pokemon
  var body: some View {
    Chart(pokemon.stats) { stat in
      BarMark(x: .value("Value", stat.value), y: .value("Stat", stat.label))
        .annotation(position: .trailing) {
          Text("\(stat.value)").padding([.top], -5).foregroundColor(.secondary)
            .font(.subheadline)
        }
    }.frame(height: 200).padding([.leading, .trailing, .bottom])
      .foregroundColor(Color(pokemon.types![0].capitalized))
      .chartXScale(domain: 0 ... pokemon.highestStat.value + 10)
  }
}

#Preview {
  Stats().environmentObject(SamplePokemon.samplePokemon)
}
