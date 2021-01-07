//
//  ProteinsViewController.swift
//  swifty-proteins
//
//  Created by arthur on 04/01/2021.
//

import UIKit
import SceneKit

class ProteinsViewController: UIViewController, SCNSceneRendererDelegate {

    var scnView: SCNView!
    var scnScene: SCNScene!
    var cameraNode: SCNNode!
    var dataset: [String.SubSequence]?
    var periodic: Periodic?
    var atoms = ProteinsModel()
    var Camera = CameraModel()
    var Menu = MenuController()
    var DataShow = MendeleievController()
    
    @IBOutlet weak var TabBar: UITabBar!
    @IBOutlet weak var SceneView: UIView!
    @IBOutlet weak var DataView: UIView!
    
    
    var dataRepresent:[String.SubSequence]? {
        didSet {
            dataset = dataRepresent
        }
    }
    
    var periodicValue:Periodic? {
        didSet {
            periodic = periodicValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        initScene()
        initCamera()
        createAtoms()
        
        scnView.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action:
                   #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
        
        Menu.setData(cam: Camera, v: SceneView as! SCNView, scnV: scnView, scnS: scnScene)
        TabBar.delegate = Menu
        DataView.accessibilityElementsHidden = true
    }
    
    func initView() {
        
        scnView = (SceneView as! SCNView)
        scnView.allowsCameraControl = true
        scnView.autoenablesDefaultLighting = true
        scnView.backgroundColor = UIColor(red: 191/255, green: 187/255, blue: 188/255, alpha: 1)
    }
    
    func initScene() {
        
        scnScene = SCNScene()
        scnView.scene = scnScene
        scnView.isPlaying = true
    }
    
    func initCamera() {
        
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.fieldOfView = CGFloat(Camera.FOV)
        
        cameraNode.position = SCNVector3(x: 0, y: 5, z: 10)
        cameraNode.name = "Camera"
        scnScene.rootNode.addChildNode(cameraNode)
    }
    
    func createAtoms() {
        
        var i = 0;
        while i < dataset!.count {
            
            let infos = String(dataset![i]).condensed.split(separator: " ")
            if infos[0] == "ATOM" {
                
                createSphere(x: String(infos[6]), y: String(infos[7]), z: String(infos[8]), color: atoms.GetColor(atom: String(infos[11])), name: String(infos[11]))
            } else if infos[0] == "CONECT" {
                
                getConnections(data: infos, content: dataset!)
            }
            i += 1
        }
    }
    
    func getConnections(data: [String.SubSequence], content: [String.SubSequence]) {
        
        var i = 1;
        let index_from = Int(data[1])! - 1
        while (i < data.count - 1) {
            
            let index_to = Int(data[i + 1])! - 1
            
            let searchfrom = String(content[index_from]).condensed.split(separator: " ")
            let searchto = String(content[index_to]).condensed.split(separator: " ")
            
            let from = SCNVector3(x: Float(searchfrom[6])!, y: Float(searchfrom[7])!, z: Float(searchfrom[8])!)
            let to = SCNVector3(x: Float(searchto[6])!, y: Float(searchto[7])!, z: Float(searchto[8])!)
            
            createCylindre(to: to, from: from, color: atoms.GetColor(atom: String(searchto[11])))
            i += 1
        }
    }
    
    func createCylindre(to: SCNVector3, from: SCNVector3, color: UIColor) {
        
        let vector = to - from
        let length = vector.length()
        
        let cylinder = SCNCylinder(radius: CGFloat(atoms.GetCylinderRadius()), height: CGFloat(length))
        cylinder.radialSegmentCount = 6
        cylinder.firstMaterial?.diffuse.contents = color

        let node = SCNNode(geometry: cylinder)

        node.position = (to + from) / 2
        node.eulerAngles = SCNVector3Make(Float(CGFloat(Double.pi/2)), acos((to.z-from.z)/length), atan2((to.y-from.y), (to.x-from.x) ))
        scnScene.rootNode.addChildNode(node)
        
    }
    
    func createSphere(x: String, y: String, z: String, color: UIColor, name: String) {
        
        let sphere = SCNSphere(radius: CGFloat(atoms.GetRadius()))
        sphere.firstMaterial?.diffuse.contents = color
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.position = SCNVector3(x: Float(x)!, y: Float(y)!, z: Float(z)!)
        sphereNode.name = name
            
        scnScene.rootNode.addChildNode(sphereNode)
    }
    
    @objc func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        
        let sceneView = SceneView as! SCNView
        let p = gestureRecognize.location(in: scnView)
        let hitResults = sceneView.hitTest(p, options: [:])

        if hitResults.count > 0 {
            
            let result: SCNHitTestResult = hitResults[0]
            if (((result.node.geometry as? SCNSphere)?.radius) != nil) {
                
                DataView.accessibilityElementsHidden = false
                DataShow.Setup(ModelView: DataView as! SCNView, atom: result.node.name!, data: periodic)
            }
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
    
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Share(_ sender: Any) {
    
        let scnView = SceneView as! SCNView
            
        DispatchQueue.main.async {

            let screenshot = scnView.snapshot()
            let imageShare = [ screenshot ]
            let activityViewController = UIActivityViewController(activityItems: imageShare , applicationActivities: nil)
                    activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
}
