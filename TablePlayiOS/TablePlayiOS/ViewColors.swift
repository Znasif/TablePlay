//
//  ViewColors.swift
//  TablePlayiOS
//
//  Created by Nasif Zaman on 4/20/24.
//

import Foundation
import RealityKit
import SwiftUI

extension Color {
    
    static let teamColors: [String: [[Int]]] = [
        "ARI": [[151, 35, 63], [0, 0, 0], [255, 182, 18]],
        "ATL": [[167, 25, 48], [0, 0, 0], [165, 172, 175]],
        "BAL": [[26, 25, 95],[0, 0, 0],[158, 124, 12],[198, 12, 14]],
        "BUF": [[0, 51, 141],[198, 12, 48]],
        "CAR": [[0, 133, 202], [16, 24, 32], [191, 192, 191]],
        "CHI": [[11, 22, 42],[200, 56, 3]],
        "CIN": [[251, 79, 20],[0, 0, 0]],
        "CLE": [[49, 29, 0], [255, 60, 0]],
        "DAL": [[0, 53, 148],[0, 34, 68],[134, 147, 151],[127, 150, 149]],
        "DEN": [[251, 79, 20],[0, 34, 68]],
        "DET": [[0, 118, 182],[176, 183, 188],[0, 0, 0],[255, 255, 255]],
        "GB": [[24, 48, 40],[255, 184, 28]],
        "HOU": [[3, 32, 47],[167, 25, 48]],
        "IND": [[0, 44, 95],[162, 170, 173]],
        "JAX": [[16, 24, 32],[215, 162, 42],[159, 121, 44],[0, 103, 120]],
        "KC": [[227, 24, 55],[255, 184, 28]],
        "LA": [[0, 53, 148], [255, 163, 0], [255, 130, 0], [255, 209, 0], [255, 255, 255]],
        "LAC": [[0, 128, 198],[255, 194, 14],[255, 255, 255]],
        "LV": [[0, 0, 0],[165, 172, 175]],
        "MIA": [[0, 142, 151],[252, 76, 2],[0, 87, 120]],
        "MIN": [[79, 38, 131],[255, 198, 47]],
        "NE": [[0, 34, 68],[198, 12, 48],[176, 183, 188]],
        "NO": [[211, 188, 141], [16, 24, 31]],
        "NYG": [[1, 35, 82], [163, 13, 45], [155, 161, 162]],
        "NYJ": [[18, 87, 64],[0, 0, 0],[255, 255, 255]],
        "OAK": [[255,255,255],[0,0,0]],
        "PHI": [[0, 76, 84], [165, 172, 175], [186, 202, 211], [0, 0, 0], [95, 96, 98]],
        "PIT": [[255, 182, 18],[16, 24, 32],[0, 48, 135],[198, 12, 48],[165, 172, 175]],
        "SEA": [[0, 34, 68], [105, 190, 40], [165, 172, 175]],
        "SF": [[170, 0, 0], [173, 153, 93]],
        "TB": [[213, 10, 10], [255, 121, 0], [10, 10, 8], [177, 186, 191], [52, 48, 43]],
        "TEN": [[12, 35, 64],[75, 146, 219],[200, 16, 46],[138, 141, 143]],
        "WAS": [[90, 20, 20], [255, 182, 18]],
    ]
    
    static func forTeam(_ teamAbbreviation: String) -> [Color] {
        guard let teamclr = teamColors[teamAbbreviation] else {
            return [Color.clear]
        }
        
        var colors: [Color] = []//[.red, .green, .blue]
          for color in teamclr {
            let clr = Color(red: Double(color[0]) / 255.0, green: Double(color[1]) / 255.0, blue: Double(color[2]) / 255.0)
            colors.append(clr)
          }
        return colors
    }}


struct ColorMosaic: View {
  let team: String

  var body: some View {
      let team_colors = Color.forTeam(team)
      ZStack {
          ForEach(0 ..< team_colors.count, id: \.self) { index in
              Rectangle()
                  .fill(team_colors[index])
                  .scaleEffect(CGFloat(team_colors.count - index) / CGFloat(team_colors.count))
                  //.offset(x: CGFloat(index) * 5, y: CGFloat(index) * 5) // Adjust offsets for desired overlap
          }
          Text(team)
              .foregroundColor(team_colors[team_colors.count-1])
              .contrast(-1.0)
          // Adjust text color for contrast
              .fontWeight(.bold)
      }
  }
}

struct ColorVsMosaic: View {
  let text: String

  var body: some View {
      let home = String(text.split(separator: " ")[0])
      let away = String(text.split(separator: " ")[1])
      let week = String(text.split(separator: " ")[3])
        VStack{
            ColorMosaic(team: home)
            ColorMosaic(team: away)
            Text("Week : "+week)
                .foregroundColor(.white)
                .contrast(1.0)
            // Adjust text color for contrast
                .fontWeight(.bold)
                .shadow(color: .black, radius: 5)
        }
  }
}
