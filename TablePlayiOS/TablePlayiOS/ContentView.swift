//
//  ContentView.swift
//  TablePlayiOS
//
//  Created by Nasif Zaman on 4/18/24.
//

import SwiftUI
import RealityKit

struct LightBlueTextButton: View {
  let text: String

  var body: some View {
    Text(text)
      .foregroundColor(.black) // Text color
      .padding() // Add some padding inside the button
      .background(Color.lightBlue) // Light blue background
      .cornerRadius(10) // Rounded corners for a button-like look
  }
}

// Light blue color definition (optional)
extension Color {
  static var lightBlue: Color {
    Color(red: 0.8, green: 0.9, blue: 1)
  }
}


struct ContentView : View {
    var body: some View {
        ZStack(alignment: .center){
            ARViewContainer().edgesIgnoringSafeArea(.all)
            ScrollView(.horizontal, showsIndicators: false){
                HStack(spacing: 30){
                    ForEach(GameData.listGames(), id: \.self) { g in
                        LightBlueTextButton(text: g) // Each Text view conforms to View
                    }
                }
            }
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)

        // Create a cube model
        let mesh = MeshResource.generateBox(size: 0.1, cornerRadius: 0.005)
        let material = SimpleMaterial(color: .gray, roughness: 0.15, isMetallic: true)
        let model = ModelEntity(mesh: mesh, materials: [material])
        model.transform.translation.y = 0.05

        // Create horizontal plane anchor for the content
        let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: SIMD2<Float>(0.2, 0.2)))
        anchor.children.append(model)

        // Add the horizontal plane anchor to the scene
        arView.scene.anchors.append(anchor)

        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

#Preview {
    ContentView()
}
