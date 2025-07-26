//
//  SamplePokemon.swift
//  Dex3
//
//  Created by Rafael Almeida on 1/17/24.
//

import CoreData
import Foundation

enum SamplePokemon {
  static let samplePokemon = {
    let context = PersistenceController.preview.container.viewContext
    let fetchRequest: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
    fetchRequest.fetchLimit = 1
    let results = try! context.fetch(fetchRequest)
    return results.first!
  }()
}
