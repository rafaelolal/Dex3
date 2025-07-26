//
//  TempPokemon.swift
//  Dex3
//
//  Created by Rafael Almeida on 1/16/24.
//

import Foundation

struct TempPokemon: Codable {
  let name: String
  let id: Int
  let types: [String]
  var hp = 0
  var attack = 0
  var defense = 0
  var specialAttack = 0
  var specialDefense = 0
  var speed = 0
  let sprite: URL
  let shiny: URL

  enum PokemonDictionaryKeys: String, CodingKey {
    case id
    case name
    case types
    case stats
    case sprites

    enum TypeDictionaryKeys: String, CodingKey {
      case type

      enum TypeKeys: String, CodingKey {
        case name
      }
    }

    enum StatDictionaryKeys: String, CodingKey {
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
    let container = try decoder.container(keyedBy: PokemonDictionaryKeys.self)

    id = try container.decode(Int.self, forKey: .id)
    name = try container.decode(String.self, forKey: .name)
    var decodedTypes: [String] = []
    var typesContainer = try container.nestedUnkeyedContainer(forKey: .types)
    while !typesContainer.isAtEnd {
      let typesDictionaryContainer = try typesContainer
        .nestedContainer(keyedBy: PokemonDictionaryKeys.TypeDictionaryKeys.self)
      let typeContainer = try typesDictionaryContainer.nestedContainer(
        keyedBy: PokemonDictionaryKeys.TypeDictionaryKeys.TypeKeys.self,
        forKey: .type
      )
      let type = try typeContainer.decode(String.self, forKey: .name)
      decodedTypes.append(type)
    }

    types = decodedTypes

    var statsContainer = try container.nestedUnkeyedContainer(forKey: .stats)
    while !statsContainer.isAtEnd {
      let statsDictionaryContainer = try statsContainer
        .nestedContainer(keyedBy: PokemonDictionaryKeys.StatDictionaryKeys
          .self)
      let statContainer = try statsDictionaryContainer.nestedContainer(
        keyedBy: PokemonDictionaryKeys.StatDictionaryKeys.StatKeys.self,
        forKey: .stat
      )
      let statName = try statContainer.decode(String.self, forKey: .name)
      let statValue = try statsDictionaryContainer.decode(
        Int.self,
        forKey: .value
      )
      switch statName {
      case "hp":
        hp = statValue
      case "attack":
        attack = statValue
      case "defense":
        defense = statValue
      case "special-attack":
        specialAttack = statValue
      case "special-defense":
        specialDefense = statValue
      case "speed":
        speed = statValue
      default:
        print("Wow")
      }
    }

    let spriteContainer = try container.nestedContainer(
      keyedBy: PokemonDictionaryKeys.SpriteDictionaryKeys.self,
      forKey: .sprites
    )
    sprite = try spriteContainer.decode(URL.self, forKey: .sprite)
    shiny = try spriteContainer.decode(URL.self, forKey: .shiny)
  }
}
