//
//  NavViews.swift
//  TablePlayiOS
//
//  Created by Nasif Zaman on 4/20/24.
//

import Foundation
import RealityKit
import SwiftUI

//struct GameVsButton: View {
//  let text: String
//  @Binding var selectedGame: Int
//  @Binding var showPlaylist: Bool
//  let action: () -> Void
//
//  var body: some View {
//      NavigationView(){
//          Button(action: {
//              selectedGame = Int(text.split(separator: " ")[2]) ?? 0
//              print(selectedGame)
//              showPlaylist = true
//          })
//          {
//              ColorVsMosaic(text: text).frame(width: 200.0, height: 200.0)
//          }
//      }
//  }
//}


struct GameVsButton: View {
  let text: String
  //@Binding var showPlaylist: Bool
  let action: () -> Void

  var body: some View {
    NavigationLink {
      PlayList(gameId: Int(text.split(separator: " ")[2]) ?? 0) // Pass bindings to Playlist view
    } label: {
      ColorVsMosaic(text: text).frame(width: 200.0, height: 200.0)
    }
  }
}

struct GameList : View {
    var body: some View {
        NavigationView(){
            ZStack(alignment: .center){
                //ARViewContainer().edgesIgnoringSafeArea(.all)
                VStack(spacing: 30){
                    Text("Season : 2020")
                        .foregroundColor(.orange)
                        .contrast(1.0)
                    // Adjust text color for contrast
                        .fontWeight(.bold)
                        .font(.system(size: 36, weight: .bold))
                        .shadow(color: .black, radius: 5)
                    ScrollView(.vertical, showsIndicators: false){
                        VStack(spacing: 30){
                            ForEach(GameData.listGames(), id: \.self) { g in
                                GameVsButton(text: g){
                                    
                                } // Each Text view conforms to View
                            }
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}



struct SelectPlayButton: View {
  let selectedPlay: Int
  let action: () -> Void

  var body: some View {
      NavigationLink {
          ARPlayView(selectedPlay: selectedPlay) // Pass bindings to Playlist view
      } label: {
          ZStack(content: {
              let xx = 200.0
              let yy = 200.0
              Rectangle()
                  .fill(.orange).frame(width: xx,height: yy)
              Text(String(selectedPlay))
                  .foregroundColor(.black)
                  .contrast(-1.0)
              // Adjust text color for contrast
                  .fontWeight(.bold)
              })
          }
          
      }
//      .swipeActions(edge: .trailing) {
//          Button(role: .destructive) {
//              // Trailing swipe action
//          } label: {
//              Label("More", systemImage: "ellipsis")
//          }
//      }
}

struct PlayList : View {
    let gameId: Int
    var body: some View {
        NavigationView{
            ZStack(alignment: .center){
                //ARViewContainer().edgesIgnoringSafeArea(.all)
                ScrollView(.vertical, showsIndicators: false){
                    VStack(spacing: 30){
                        ForEach(GameData.listPlays(gameId: gameId), id: \.self) { g in
                            SelectPlayButton(selectedPlay: g){
                                
                            }// Each Text view conforms to View
                        }
                    }
                }
            }
        }
    }
}


struct FavoriteButton: View {
  let team: String
  let action: () -> Void

  var body: some View {
      Button(action: {
          
      }) {
          VStack(content: {
              let xx = 200.0
              let yy = 200.0
              ColorMosaic(team: team).frame(width: xx, height: yy)
          })}
      
//      }.swipeActions(edge: .trailing) {
//          Button(role: .destructive) {
//              
//          } label: {
//              Label("More", systemImage: "ellipsis")
//          }
//      }
  }
}

struct FavoriteList : View {
    var body: some View {
        ZStack(alignment: .center){
            ARViewContainer().edgesIgnoringSafeArea(.all)
            ScrollView(.vertical, showsIndicators: false){
                VStack(spacing: 30){
//                    ForEach(GameData.listPlays(gameId: 0), id: \.self) { g in
//                        FavoriteButton(team: g){
//                            
//                        }// Each Text view conforms to View
//                    }
                    }
                }
            }
        }
    }


struct ARPlayView : View {
    let selectedPlay: Int
    var body: some View {
        ZStack(alignment: .center){
            NFLARViewContainer(selectedPlay: selectedPlay).edgesIgnoringSafeArea(.all)
            VStack{
                Spacer()
                Button(action: {
                    
                }){
                    Image (systemName:"checkmark" )
                        .frame (width:60, height: 60)
                        .font(.title)
                        .background (Color.green.opacity(0.75))
                        .cornerRadius (30)
                        .padding (20)
                }
                
            }
        }
    }}
