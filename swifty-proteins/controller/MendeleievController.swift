//
//  MendeleievController.swift
//  swifty-proteins
//
//  Created by arthur on 07/01/2021.
//

import UIKit
import SceneKit

class MendeleievController: NSObject, SCNSceneRendererDelegate {
 
    var scnView: SCNView!
    var scnScene: SCNScene!
    var cameraNode: SCNNode!
    var SceneView: SCNView?
    var DataPeriodic = MendeleievModel()
    var periodic: Periodic?
    
    func Setup(ModelView: SCNView, atom: String, data: Periodic?, name: UILabel, discover: UILabel, details: UITextView) {
        
        SceneView = ModelView
        periodic = data
        
        initView()
        initScene()
        initCamera()
        
        DataPeriodic.setup(data: periodic)
        let infos = DataPeriodic.getAtomsBySymbol(name: atom)
        if infos != nil {
            
            setupInformations(data: infos, name: name, discover: discover, details: details)
        } else {
            // affihcer quon a pas assez dinfos
        }
        
        createSphere(x: "0", y: "0", z: "0", color: ProteinsModel().GetColor(atom: atom))
    }
    
    func setupInformations(data: AtomDetail?, name: UILabel, discover: UILabel, details: UITextView) {
        
        name.text = data?.name
        discover.text = data?.discovered_by
        
        var mass = data?.atomic_mass
        if mass == nil {
            mass = 0.0
        }
        
        var density = data?.density
        if density == nil {
            density = 0.0
        }
        
        var molar_heat = data?.molar_heat
        if molar_heat == nil {
            molar_heat = 0.0
        }
        details.text = "m: " + String(mass!) + ", D: " + String(density!) + ", M: " + String(molar_heat!)
    }
    
    func initView() {
        
        scnView = SceneView! as SCNView
        scnView.allowsCameraControl = true
        scnView.autoenablesDefaultLighting = true
        scnView.backgroundColor = UIColor(red: 209/255, green: 204/255, blue: 205/255, alpha: 0.8)
    }
    
    func initScene() {
        
        scnScene = SCNScene()
        scnView.scene = scnScene
        scnView.isPlaying = true
    }
    
    func initCamera() {
        
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.fieldOfView = CGFloat(100)
        
        cameraNode.position = SCNVector3(x: 0, y: -1, z: 10)
        cameraNode.name = "Camera"
        scnScene.rootNode.addChildNode(cameraNode)
    }
    
    func createSphere(x: String, y: String, z: String, color: UIColor) {
        
        let sphere = SCNSphere(radius: CGFloat(5))
        sphere.firstMaterial?.diffuse.contents = color
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.position = SCNVector3(x: Float(x)!, y: Float(y)!, z: Float(z)!)
            
        scnScene.rootNode.addChildNode(sphereNode)
    }
}
