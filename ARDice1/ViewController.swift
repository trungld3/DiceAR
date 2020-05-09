//
//  ViewController.swift
//  ARDice
//
//  Created by TrungLD on 5/7/20.
//  Copyright © 2020 TrungLD. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // Set the view's delegate
        sceneView.delegate = self

//        let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
        
//        let sharepe = SCNSphere(radius: 0.2)
//
//        let material = SCNMaterial()
//        material.diffuse.contents = UIImage(named: "art.scnassets/8k_jupiter.jpg")
//
//        sharepe.materials = [material]
//
//        let node =  SCNNode()
//        node.position = SCNVector3( x : 0 , y : 0.1 , z : -0.5)
//        node.geometry = sharepe
//        sceneView.scene.rootNode.addChildNode(node)
        sceneView.autoenablesDefaultLighting = true
        
        // Create a new scene
//        let Dicescene = SCNScene(named: "art.scnassets/diceCollada.scn")!
//
//      //   Set the scene to the view
//        if let diceNode = Dicescene.rootNode.childNode(withName: "Dice", recursively:  true) {
//            diceNode.position = SCNVector3( 0, 0  , -0.1)
//            sceneView.scene.rootNode.addChildNode(diceNode)
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        print("Session is supported = \(ARConfiguration.isSupported)")
        print("World tracking is support =\(ARWorldTrackingConfiguration.isSupported)")
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: sceneView)
            
            let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            
            if let hitResult =  results.first {
                 // Create a new scene
                        let Dicescene = SCNScene(named: "art.scnassets/diceCollada.scn")!
                
                      //   Set the scene to the view
                        if let diceNode = Dicescene.rootNode.childNode(withName: "Dice", recursively:  true) {
                            diceNode.position = SCNVector3( hitResult.worldTransform.columns.3.x,
                                                            hitResult.worldTransform.columns.3.y + diceNode.boundingSphere.radius
                                , hitResult.worldTransform.columns.3.z)
                            sceneView.scene.rootNode.addChildNode(diceNode)
                            
                            
                            let radomX = Float (arc4random_uniform(4) + 1 ) * (Float.pi/2)
                            let radomZ = Float( arc4random_uniform(4) + 1) * (Float.pi/2)
                            
                            diceNode.runAction(SCNAction.rotateBy(
                                x: CGFloat(radomX * 5)
                                , y: 0,
                                  z: CGFloat(radomZ * 5),
                                  duration: 0.5)
                            )
                        }
            }
        }
    }
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor is ARPlaneAnchor {
            let placeAnchor =  anchor as! ARPlaneAnchor
            
            let place = SCNPlane( width: CGFloat(placeAnchor.extent.x)  , height: CGFloat(placeAnchor.extent.z))
           
            let     planceNode = SCNNode()
            planceNode.position = SCNVector3(x: placeAnchor.center.x, y: 0, z: placeAnchor.center.z)
            planceNode.transform = SCNMatrix4MakeRotation(-(Float.pi/2), 1, 0, 0)
            
            let gridMaterial = SCNMaterial()
            gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
           
            place.materials = [gridMaterial]
            planceNode.geometry = place
            
            node.addChildNode(planceNode)
        }
        else {
             return
        }
    }
}
