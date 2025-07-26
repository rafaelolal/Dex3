//
//  Dex3Widget.swift
//  Dex3Widget
//
//  Created by Rafael Almeida on 1/18/24.
//

import CoreData
import SwiftUI
import WidgetKit

struct Provider: AppIntentTimelineProvider {
  var randomPokemon: Pokemon {
    let context = PersistenceController.shared.container.viewContext
    let fetchRequest: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()

    var results: [Pokemon] = []

    do {
      results = try context.fetch(fetchRequest)
    } catch {
      print("Couldn't fetch \(error)")
    }

    if let randomPokemon = results.randomElement() {
      return randomPokemon
    }

    return SamplePokemon.samplePokemon
  }

  func placeholder(in _: Context) -> SimpleEntry {
    SimpleEntry(
      date: Date(),
      configuration: ConfigurationAppIntent(),
      pokemon: SamplePokemon.samplePokemon
    )
  }

  func snapshot(for configuration: ConfigurationAppIntent,
                in _: Context) async -> SimpleEntry
  {
    SimpleEntry(
      date: Date(),
      configuration: configuration,
      pokemon: randomPokemon
    )
  }

  func timeline(for configuration: ConfigurationAppIntent,
                in _: Context) async -> Timeline<SimpleEntry>
  {
    var entries: [SimpleEntry] = []

    // Generate a timeline consisting of five entries an hour apart, starting
    // from the current date.
    let currentDate = Date()
    for hourOffset in 0 ..< 5 {
      let entryDate = Calendar.current.date(
        byAdding: .hour,
        value: hourOffset,
        to: currentDate
      )!
      let entry = SimpleEntry(
        date: entryDate,
        configuration: configuration,
        pokemon: randomPokemon
      )
      entries.append(entry)
    }

    return Timeline(entries: entries, policy: .atEnd)
  }
}

struct SimpleEntry: TimelineEntry {
  let date: Date
  let configuration: ConfigurationAppIntent

  let pokemon: Pokemon
}

struct Dex3WidgetEntryView: View {
  @Environment(\.widgetFamily) var widgetSize
  var entry: Provider.Entry

  var body: some View {
    VStack {
      switch widgetSize {
      case .systemSmall:
        WidgetPokemon(widgetSize: .small).environmentObject(entry.pokemon)
      case .systemMedium:
        WidgetPokemon(widgetSize: .medium).environmentObject(entry.pokemon)
      case .systemLarge:
        WidgetPokemon(widgetSize: .large).environmentObject(entry.pokemon)
      default:
        WidgetPokemon(widgetSize: .small).environmentObject(entry.pokemon)
      }
    }
  }
}

struct Dex3Widget: Widget {
  let kind: String = "Dex3Widget"

  var body: some WidgetConfiguration {
    AppIntentConfiguration(
      kind: kind,
      intent: ConfigurationAppIntent.self,
      provider: Provider()
    ) { entry in
      Dex3WidgetEntryView(entry: entry)
        .containerBackground(.fill.tertiary, for: .widget)
    }
  }
}

private extension ConfigurationAppIntent {
  static var smiley: ConfigurationAppIntent {
    let intent = ConfigurationAppIntent()
    intent.favoriteEmoji = "😀"
    return intent
  }
}

#Preview(as: .systemSmall) {
  Dex3Widget()
} timeline: {
  SimpleEntry(
    date: .now,
    configuration: .smiley,
    pokemon: SamplePokemon.samplePokemon
  )
}

#Preview(as: .systemMedium) {
  Dex3Widget()
} timeline: {
  SimpleEntry(
    date: .now,
    configuration: .smiley,
    pokemon: SamplePokemon.samplePokemon
  )
}

#Preview(as: .systemLarge) {
  Dex3Widget()
} timeline: {
  SimpleEntry(
    date: .now,
    configuration: .smiley,
    pokemon: SamplePokemon.samplePokemon
  )
}
