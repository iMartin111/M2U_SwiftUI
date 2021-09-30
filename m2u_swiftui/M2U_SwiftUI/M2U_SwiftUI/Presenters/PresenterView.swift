//
//  ContentView.swift
//  M2U_SwiftUI
//
//  Created by Yan Akhrameev on 29/09/21.
//

import SwiftUI

struct PresenterView: View {
    @State private var likeButtonStatus: Bool = false
    
    @ObservedObject var networkManager = NetworkManager()
    var body: some View {
        VStack {
            ZStack {
                Image(uiImage: networkManager.image ?? UIImage())
                    .resizable()
                    .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height / 2, alignment: .center)
                .aspectRatio(contentMode: .fit)
                VStack {
                    Spacer()
                    HStack {
                        VStack {
                            Text(networkManager.movie?.name ?? "error")
                                .font(.system(size: 30))
                                .fontWeight(.semibold)
                            .foregroundColor(.green)
                            HStack {
                                Text("❤️\(String(networkManager.movie?.likes ?? 0)) Likes")
                                    .foregroundColor(.green)
                                Text("🏆 \(String(networkManager.movie?.views ?? 0))")
                                    .foregroundColor(.green)
                            }
                        }
                        Spacer()
                        Button {
                            likeButtonStatus.toggle()
                        } label: {
                            if likeButtonStatus {
                                Image(systemName: "heart.fill")
                                    .resizable()
                                    .frame(width: 25, height: 25, alignment: .center)
                            } else {
                                Image(systemName: "heart")
                                    .resizable()
                                    .frame(width: 25, height: 25, alignment: .center)
                            }
                        }
                        .padding()
                    }
                }
            }
            List(networkManager.movies?.results ?? [Movie](), rowContent: { movie in
                HStack {
                    VStack {
                        Text(movie.name)
                        
                        Text("Released: \(movie.year)")
                            .font(.system(size: 15))
                    }
                    

                }
            })
            .listStyle(.plain)
        }
        .onAppear {
            
            self.networkManager.fetchMovie()
            self.networkManager.fetchRelatedMovies()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PresenterView()
    }
}
