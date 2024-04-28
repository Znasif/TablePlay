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

class FootModel{
    var modelName: String
    var modelEntity: ModelEntity?
    
    //private var cancellable: AnyCancellable? = nil
    
    init (modelName: String) {
        self.modelName = modelName
        let filename = modelName + ".usdz"
        /*lazy var cancellable = ModelEntity.loadModelAsync(named: filename)
            .sink (receiveCompletion: { loadCompletion in
            }, receiveValue: { modelEntity in
                self.modelEntity = modelEntity
            })*/
        self.modelEntity = try! ModelEntity.loadModel(named: filename)
    }
}

func textGen(textString: String) -> ModelEntity {
      
      let materialVar = SimpleMaterial(color: .white, roughness: 0, isMetallic: false)
      
      let depthVar: Float = 0.001
      let fontVar = UIFont.systemFont(ofSize: 0.01)
      let containerFrameVar = CGRect(x: -0.05, y: -0.1, width: 0.1, height: 0.1)
      let alignmentVar: CTTextAlignment = .center
      let lineBreakModeVar : CTLineBreakMode = .byWordWrapping
      
      let textMeshResource : MeshResource = .generateText(textString,
                                         extrusionDepth: depthVar,
                                         font: fontVar,
                                         containerFrame: containerFrameVar,
                                         alignment: alignmentVar,
                                         lineBreakMode: lineBreakModeVar)
      
      let textEntity = ModelEntity(mesh: textMeshResource, materials: [materialVar])
      
      return textEntity
  }

class Preserve{
    static var fieldEntity: Entity = Entity()
    static var models: [FootModel] = {
        
        var availableModels: [FootModel] = []
        for i in ["playerHome", "playerAway", "footBallModel"] {
            let model = FootModel(modelName: i)
            availableModels.append(model)
        }
        return availableModels
    }()
}
    
struct NFLARViewContainer: UIViewRepresentable {
        let selectedPlay: Int
        @Binding var placeNow: Bool
        @State var fesq: FocusEntity?
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
                    Preserve.fieldEntity = ModelEntity(mesh: barMesh, materials: [barMaterial])
                    fesq = arView.focusEntity
                    
                    Preserve.fieldEntity.transform.translation = SIMD3<Float>(x: 0.0, y: 0.001, z: 0.0)
                    fesq!.addChild(Preserve.fieldEntity)
                    
                    arView.scene.addAnchor(fesq!)
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
        
        func updateUIView(_ uiView: ARView, context: Context) {
            if placeNow{
                guard let fsq = fesq else{
                    return
                }
                //var et = textGen(textString: "Testing")
                //et.transform.scale = SIMD3<Float>(x: 10.0, y: 10.0, z: 10.0)
                //var anch = AnchorEntity(world: fsq.position)
                //anch.addChild(et)
                Preserve.fieldEntity.removeFromParent(preservingWorldTransform: false)
                Preserve.fieldEntity.transform = fsq.transform
                Preserve.fieldEntity.transform.scale = SIMD3<Float>(x: 2.0, y: 2.0, z: 2.0)
                let anch = AnchorEntity(world: fsq.position)
                fsq.isEnabled = false
                anch.addChild(Preserve.fieldEntity)
                let play = GameData.games[GameData.selectedGame].plays[selectedPlay]
                //print(play.football.x)
                //let position = simd_float3(x: 0.5, y: 5, z: 0.5)
                /*let cubeSize = SIMD3<Float>(0.005, 0.025, 0.005) // width, height, depth
                let cubeMesh = MeshResource.generateBox(size: cubeSize)
                var cubeMaterial = UnlitMaterial()
                cubeMaterial.color = PhysicallyBasedMaterial
                    .BaseColor(tint: .red)*/
                var topLeft: SIMD3<Float> = SIMD3<Float>(x: -0.35, y: 0.01, z: -0.18)
                var bottomRight: SIMD3<Float> = SIMD3<Float>(x: 0.35, y: 0.01, z: 0.18)
                var animationInterval: Float = 0.15
                //let animationDefinition = SampledAnimation(frames: transforms, frameInterval: 0.75, bindTarget: .transform)
                
                //let animationResource = try! AnimationResource.generate(with: animationDefinition)
                //entity.playAnimation(animationResource)
                var homeMesh = try! ModelEntity.loadModel(named: "playerHome")
                for p in play.home{
                    let cubeEntity = homeMesh.clone(recursive: true)//ModelEntity(mesh: cubeMesh, materials: [cubeMaterial])
                     var transHome: [Transform] = []
                     for i in 0..<p.locomotion.x.count{
                         var t: Transform = Transform()
                         t.scale = SIMD3<Float>(0.005, 0.005, 0.005)
                         t.translation = simd_float3(x: topLeft.x+p.locomotion.x[i]*(bottomRight.x-topLeft.x), y: 0.01, z: topLeft.z+p.locomotion.y[i]*(bottomRight.z-topLeft.z))
                         t.rotation = simd_quatf(angle: .pi/2, axis: SIMD3<Float>(x: 0.0, y: 0.0, z: 1.0))*simd_quatf(angle: .pi/2, axis: SIMD3<Float>(x: 0.0, y: 1.0, z: 0.0))*simd_quatf(angle: .pi*(180.0-p.locomotion.orientation![i])*2/360.0, axis: SIMD3<Float>(x: 0.0, y: 0.0, z: 1.0))
                         transHome.append(t)
                         cubeEntity.transform = t
                     }
                     let animationDefinition = SampledAnimation(frames: transHome, frameInterval: animationInterval, bindTarget: .transform)
                     let animationResource = try! AnimationResource.generate(with: animationDefinition)
                     cubeEntity.playAnimation(animationResource)
                     Preserve.fieldEntity.addChild(cubeEntity)
                 }
                
                 var awayMesh = try! ModelEntity.loadModel(named: "playerAway")
                 for p in play.away{
                     let cubeEntity = awayMesh.clone(recursive: true)
                     var transAway: [Transform] = []
                     for i in 0..<p.locomotion.x.count{
                         var t: Transform = Transform()
                         t.scale = SIMD3<Float>(0.005, 0.005, 0.005)
                         t.translation = simd_float3(x: topLeft.x+p.locomotion.x[i]*(bottomRight.x-topLeft.x), y: 0.01, z: topLeft.z+p.locomotion.y[i]*(bottomRight.z-topLeft.z))
                         t.rotation = simd_quatf(angle: .pi/2, axis: SIMD3<Float>(x: 0.0, y: 0.0, z: 1.0))*simd_quatf(angle: .pi/2, axis: SIMD3<Float>(x: 0.0, y: 1.0, z: 0.0))*simd_quatf(angle: .pi*(180.0-p.locomotion.orientation![i])*2/360.0, axis: SIMD3<Float>(x: 0.0, y: 0.0, z: 1.0))
                         transAway.append(t)
                         cubeEntity.transform = t
                     }
                     let animationDefinition = SampledAnimation(frames: transAway, frameInterval: animationInterval, bindTarget: .transform)
                     let animationResource = try! AnimationResource.generate(with: animationDefinition)
                     cubeEntity.playAnimation(animationResource)
                     Preserve.fieldEntity.addChild(cubeEntity)
                 }
                 
                 let p = play.football
                 var ball = try! ModelEntity.loadModel(named: "footBallModel")
                 var transBall: [Transform] = []
                 for i in 0..<p.x.count{
                     var t: Transform = Transform()
                     t.scale = SIMD3<Float>(0.000025, 0.000025, 0.000025)
                     t.translation = simd_float3(x: topLeft.x+p.x[i]*(bottomRight.x-topLeft.x), y: 0.08, z: topLeft.z+p.y[i]*(bottomRight.z-topLeft.z))
                     transBall.append(t)
                     ball.transform = t
                 }
                 let animationDefinition = SampledAnimation(frames: transBall, frameInterval: animationInterval, bindTarget: .transform)
                 let animationResource = try! AnimationResource.generate(with: animationDefinition)
                 ball.playAnimation(animationResource)
                Preserve.fieldEntity.addChild(ball)
                
                uiView.scene.addAnchor(anch)
            }
        }
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
