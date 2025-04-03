//
//  AboutView.swift
//  GameCatalog
//
//  Created by ben on 22/03/25.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack(spacing: 20) {
            AsyncImage(url: URL(string: "data:image/jpeg;base64,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")!) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxWidth: .infinity)
                                        .cornerRadius(12)
                                case .failure(_):
                                    Image(systemName: "photo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxWidth: .infinity)
                                        .foregroundColor(.gray)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            .padding(.horizontal)
            
            Text("Diki Haryadi")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("iOS Developer")
                .font(.headline)
                .foregroundColor(.gray)
            
            VStack(alignment: .leading, spacing: 10) {
                InfoRow(icon: "envelope.fill", text: "unpam.dik@gmail.com.com")
                InfoRow(icon: "link", text: "github.com/diki-haryadi")
                InfoRow(icon: "location.fill", text: "Jakarta, Indonesia")
            }
            .padding(.top)
            
            Spacer()
        }
        .padding()
        .background(Color.white.edgesIgnoringSafeArea(.all))
        .navigationTitle("About Developer")
    }
}

struct InfoRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 25)
            Text(text)
                .foregroundColor(.black)
        }
    }
}

#Preview {
    NavigationView {
        AboutView()
    }
    .preferredColorScheme(.dark)
}
