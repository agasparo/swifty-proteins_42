//
//  MenuController.swift
//  swifty-proteins
//
//  Created by arthur on 07/01/2021.
//

import UIKit
import SceneKit

class MenuController: NSObject, UITabBarDelegate {
    
    var Animationstate = true
    var Camera:CameraModel?
    var view:SCNView?
    var scnView:SCNView?
    var scnScene:SCNScene?
    
    func setData(cam: CameraModel, v: SCNView, scnV: SCNView, scnS: SCNScene) {
        
        self.Camera = cam
        self.view = v
        self.scnView = scnV
        self.scnScene = scnS
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        print ("click")
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
        let node = view!.scene!.rootNode.childNode(withName: "Camera", recursively: false)
        var newNode:SCNNode
        
        switch w {
        case 0:
            newNode = Camera!.ZoomMore(cameraNode: node!, i: i, l: l, c: c)
        case 1:
            newNode = Camera!.ZoomLess(cameraNode: node!, i: i, l: l, c: c)
        default:
            newNode = Camera!.ResetZoom(cameraNode: node!, i: i, l: l, c: c)
        }
        scnView!.pointOfView = newNode
    }
    
    func AutoRotate() {
        
        if !Animationstate {
        
            scnScene!.rootNode.removeAllAnimations()
        } else {
            
            let spin = CABasicAnimation(keyPath: "rotation")
            spin.fromValue = NSValue(scnVector4: SCNVector4(x: 0, y: 1, z: 0, w: 0))
            spin.toValue = NSValue(scnVector4: SCNVector4(x: 0, y: 1, z: 0, w: Float(CGFloat(2 * Double.pi))))
            spin.duration = 20
            spin.repeatCount = .infinity
            scnScene!.rootNode.addAnimation(spin, forKey: "spin around")
        }
        Animationstate = !Animationstate
    }
}
