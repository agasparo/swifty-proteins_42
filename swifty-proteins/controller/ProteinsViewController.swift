//
//  ProteinsViewController.swift
//  swifty-proteins
//
//  Created by arthur on 04/01/2021.
//

import UIKit
import SceneKit

class ProteinsViewController: UIViewController, UITabBarDelegate, SCNSceneRendererDelegate {

    var scnView: SCNView!
    var scnScene: SCNScene!
    var cameraNode: SCNNode!
    var dataset: [String.SubSequence]?
    var atoms = ProteinsModel()
    var Camera = CameraModel()
    var Animationstate = true
    
    @IBOutlet weak var TabBar: UITabBar!
    
    var dataRepresent:[String.SubSequence]? {
        didSet {
            dataset = dataRepresent
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TabBar.delegate = self
        
        initView()
        initScene()
        initCamera()
        createAtoms()
        
        scnView.delegate = self
    }
    
    func initView() {
        
        scnView = (self.view as! SCNView)
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
                
                createSphere(x: String(infos[6]), y: String(infos[7]), z: String(infos[8]), color: atoms.GetColor(atom: String(infos[11])))
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
    
    func createSphere(x: String, y: String, z: String, color: UIColor) {
        
        let sphere = SCNSphere(radius: CGFloat(atoms.GetRadius()))
        sphere.firstMaterial?.diffuse.contents = color
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.position = SCNVector3(x: Float(x)!, y: Float(y)!, z: Float(z)!)
            
        scnScene.rootNode.addChildNode(sphereNode)
    }
    
    @IBAction func goBack(_ sender: Any) {
    
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Share(_ sender: Any) {
    
        let scnView = self.view as! SCNView
            
        DispatchQueue.main.async {

            let screenshot = scnView.snapshot()
            let imageShare = [ screenshot ]
            let activityViewController = UIActivityViewController(activityItems: imageShare , applicationActivities: nil)
                    activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        switch tabBar.items!.firstIndex(of: item) {
        case 0:
            Zoom(w: 0, i: item, l: "+", c: tabBar.items![1])
            return
        case 1:
            Zoom(w: 1, i: item, l: "-", c: tabBar.items![0])
            return
        case 2:
            Zoom(w: 2, i: tabBar.items![0], l: "-", c: tabBar.items![1])
            return
        default:
            AutoRotate()
        }
    }
    
    func Zoom(w: Int, i: UITabBarItem, l: String, c: UITabBarItem) {
        
        Animationstate = false
        AutoRotate()
        let view = self.view as! SCNView
        let node = view.scene!.rootNode.childNode(withName: "Camera", recursively: false)
        var newNode:SCNNode
        
        switch w {
        case 0:
            newNode = Camera.ZoomMore(cameraNode: node!, i: i, l: l, c: c)
        case 1:
            newNode = Camera.ZoomLess(cameraNode: node!, i: i, l: l, c: c)
        default:
            newNode = Camera.ResetZoom(cameraNode: node!, i: i, l: l, c: c)
        }
        scnView.pointOfView = newNode
    }
    
    func AutoRotate() {
        
        if !Animationstate {
        
            scnScene.rootNode.removeAllAnimations()
        } else {
            
            let spin = CABasicAnimation(keyPath: "rotation")
            spin.fromValue = NSValue(scnVector4: SCNVector4(x: 0, y: 1, z: 0, w: 0))
            spin.toValue = NSValue(scnVector4: SCNVector4(x: 0, y: 1, z: 0, w: Float(CGFloat(2 * Double.pi))))
            spin.duration = 20
            spin.repeatCount = .infinity
            scnScene.rootNode.addAnimation(spin, forKey: "spin around")
        }
        Animationstate = !Animationstate
    }
}
