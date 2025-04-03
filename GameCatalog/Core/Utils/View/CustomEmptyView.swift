//
//  CustomEmptyView.swift
//  GameCatalog
//
//  Created on 03/04/25.
//

import SwiftUI

struct CustomEmptyView: View {
  
  var image: String
  var title: String
  
  var body: some View {
    VStack {
      Image(image)
        .resizable()
        .renderingMode(.original)
        .scaledToFit()
        .frame(width: 250, height: 250)
      
      Text(title)
        .font(.system(.body, design: .rounded))
        .multilineTextAlignment(.center)
        .foregroundColor(.gray)
    }
  }
}
