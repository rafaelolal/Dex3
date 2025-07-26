//
//  FetchImage.swift
//  Dex3
//
//  Created by Rafael Almeida on 1/18/24.
//

import SwiftUI

struct FetchImage: View {
  let url: URL?

  var body: some View {
    if let url, let imageData = try? Data(contentsOf: url),
       let uiImage = UIImage(data: imageData)
    {
      Image(uiImage: uiImage)
        .resizable()
        .scaledToFit().shadow(color: .black, radius: 10)
    } else {
      Image("bulbasaur")
    }
  }
}

#Preview {
  FetchImage(url: SamplePokemon.samplePokemon.sprite)
}
