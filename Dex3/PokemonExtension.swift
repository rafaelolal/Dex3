//
//  PokemonExtension.swift
//  Dex3
//
//  Created by Rafael Almeida on 1/17/24.
//

import Foundation

extension Pokemon {
  var background: String {
    let images = [
      "firedragon",
      "flyingbug",
      "ice",
      "normalgrasselectricpoisonfairy",
      "rockgorundsteelfightingghostdarkpsychic",
      "water",
    ]
    for image in images {
      if image.contains(types![0]) {
        return image
      }
    }

    return "normalgrasselectricpoisonfairy"
  }

  var stats: [Stat] {
    [Stat(id: 1, label: "HP", value: hp),
     Stat(id: 2, label: "Attack", value: attack),
     Stat(id: 3, label: "Defense", value: defense),
     Stat(id: 4, label: "Special Attack", value: specialAttack),
     Stat(id: 5, label: "Special Defense", value: specialDefense),
     Stat(id: 6, label: "Speed", value: speed)]
  }

  var highestStat: Stat {
    stats.max { $0.value < $1.value }!
  }

  func organizedTypes() {
    if types!.count > 1, types![0] == "normal" {
      types?.swapAt(0, 1)
    }
  }
}

struct Stat: Identifiable {
  let id: Int
  let label: String
  let value: Int16
}
