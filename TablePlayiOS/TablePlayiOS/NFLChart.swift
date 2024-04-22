//
//  NFLChart.swift
//  TablePlayiOS
//
//  Created by Nasif Zaman on 4/20/24.
//

import Charts
import SwiftUI
import RealityKit
import FocusEntity
import Combine
import ARKit
import MetalKit

extension TextureResource {
    
    // The RealityKit visionOS `TextureResource(named:in:options:) async` initializer
    // isn't available in iOS 17, so we implement our own replacement on iOS and wrap
    // both implementations in `TextureResource/loadFileAsync(named:in:options:)`.
    
#if os(visionOS)
    
    /// Loads a texture resource from a file in a bundle asynchronously.
    ///
    /// Unlike `TextureResource(named:in:options:) async` or
    /// `TextureResource.loadAsync(named:in:options:)`, this method  works on both iOS
    /// and visionOS.
    static func loadFileAsync(named name: String, in bundle: Bundle? = nil, options: TextureResource.CreateOptions = .init(semantic: nil)) async throws -> TextureResource {
        return try await TextureResource(named: name, in: bundle, options: options)
    }
    
#else // !os(visionOS)
    
    /// Loads a texture resource from a file in a bundle asynchronously.
    ///
    /// Unlike `TextureResource(named:in:options:) async` or
    /// `TextureResource.loadAsync(named:in:options:)`, this method  works on both iOS
    /// and visionOS.
    static func loadFileAsync(named name: String, in bundle: Bundle? = nil, options: TextureResource.CreateOptions = .init(semantic: nil)) async throws -> TextureResource {
        return try await withCheckedThrowingContinuation { continuation in
            var cancellable: AnyCancellable?
            cancellable = TextureResource.loadAsync(named: name, in: bundle, options: options).sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
                cancellable?.cancel()
            }, receiveValue: { entity in
                continuation.resume(returning: entity)
                cancellable?.cancel()
            })
        }
    }
    
#endif // !os(visionOS)
    
}


struct NFLARViewContainer: UIViewRepresentable {
    let selectedPlay: Int
    func makeUIView(context: Context) -> ARView {
        let arView = FocusARView(frame: .zero)//ARView(frame: .zero)
        
        // Define the size and color of the bar cube
       
        //barMaterial.color = PhysicallyBasedMaterial
        //    .BaseColor(tint: .green)
        // Create the bar cube entity
        
        Task {
                do {
                    let barSize = SIMD3<Float>(3*0.2390, 0, 3*0.1245) // width, height, depth
                    let barMesh = MeshResource.generateBox(size: barSize)
                    var barMaterial = UnlitMaterial()
                    let texture = try await TextureResource.loadFileAsync(named: "NFLField", in: .main)
                    barMaterial.color = PhysicallyBasedMaterial
                        .BaseColor(texture: .init(texture))
                    let barEntity = ModelEntity(mesh: barMesh, materials: [barMaterial])
                    guard let fesq = arView.focusEntity else{
                        return arView
                    }
                    let cubeSize = SIMD3<Float>(0.005, 0.025, 0.005) // width, height, depth
                    let cubeMesh = MeshResource.generateBox(size: cubeSize)
                    var cubeMaterial = UnlitMaterial()
                    cubeMaterial.color = PhysicallyBasedMaterial
                        .BaseColor(tint: .red)
                    
                    var play = GameData.games[GameData.selectedGame].plays[selectedPlay]
                    print(play.description.events[0])
                    //let position = simd_float3(x: 0.5, y: 5, z: 0.5)
                    
                    /*for offset in FormationController.loadDataFromCSVFile(fileName: "17_WR", subdirectory: "inputs/2020111500_3864/away/"){
                        let cubeEntity = ModelEntity(mesh: cubeMesh, materials: [cubeMaterial])
                        cubeEntity.transform.translation = offset
                        barEntity.addChild(cubeEntity)
                    }*/
                    
                    barEntity.transform.translation = SIMD3<Float>(x: 0.0, y: 0.001, z: 0.0)
                    fesq.addChild(barEntity)
                    
                    arView.scene.addAnchor(fesq)
                } catch {
                    print("Error loading texture: \(error)")
                }
            return arView
            }
        
        
        
        // Animate the bar cube through the set of points
        /*var animations: [Transform] = []
        for point in points {
            let transform = Transform(scale: .one, rotation: simd_quatf(angle: 0, axis: .one), translation: point)
            animations.append(transform)
        }
        
        // Create the animation sequence
        barEntity.move(to: animations[0], relativeTo: anchor, duration: 1, timingFunction: .linear)
        for i in 1..<animations.count {
            barEntity.move(to: animations[i], relativeTo: anchor, duration: 1, timingFunction: .linear)
        }*/
        return arView
    }
    
    func placeView(){
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
}


class FocusARView: ARView {
    enum FocusStyleChoices {
        case classic
        case material
        case color
    }

    /// Style to be displayed in the example
    let focusStyle: FocusStyleChoices = .classic
    var focusEntity: FocusEntity?
    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
        self.setupConfig()

        switch self.focusStyle {
        case .color:
            self.focusEntity = FocusEntity(on: self, focus: .plane)
        case .material:
            do {
                let onColor: MaterialColorParameter = try .texture(.load(named: "Add"))
                let offColor: MaterialColorParameter = try .texture(.load(named: "Open"))
                self.focusEntity = FocusEntity(
                    on: self,
                    style: .colored(
                        onColor: onColor, offColor: offColor,
                        nonTrackingColor: offColor
                    )
                )
            } catch {
                self.focusEntity = FocusEntity(on: self, focus: .classic)
                print("Unable to load plane textures")
                print(error.localizedDescription)
            }
        default:
            self.focusEntity = FocusEntity(on: self, focus: .classic)
        }
    }

    func setupConfig() {
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        session.run(config)
    }

    @objc required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
