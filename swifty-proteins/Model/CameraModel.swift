//
//  CameraModel.swift
//  swifty-proteins
//
//  Created by arthur on 06/01/2021.
//

import UIKit
import SceneKit

class CameraModel {
    
    var FOV:Float = 150
    let scale:Float = 10
    
    func ZoomMore(cameraNode: SCNNode, i: UITabBarItem, l: String, c: UITabBarItem) -> SCNNode {
        
        CalcFOV(type: 1)
        cameraNode.camera!.fieldOfView = CGFloat(FOV)
        SetText(i: i, l: l, c: c)
        return (cameraNode)
    }
    
    func ZoomLess(cameraNode: SCNNode, i: UITabBarItem, l: String, c: UITabBarItem) -> SCNNode {
        
        CalcFOV(type: 0)
        cameraNode.camera!.fieldOfView = CGFloat(FOV)
        SetText(i: i, l: l, c: c)
        return (cameraNode)
    }
    
    func ResetZoom(cameraNode: SCNNode, i: UITabBarItem, l: String, c: UITabBarItem) -> SCNNode {
        
        FOV = 150
        cameraNode.camera!.fieldOfView = CGFloat(FOV)
        ResetText(i: i, c: c)
        return (cameraNode)
    }
    
    func ResetText(i: UITabBarItem, c: UITabBarItem) {
        
        i.title = "zoom +"
        c.title = "zoom -"
    }
    
    func SetText(i: UITabBarItem, l: String, c: UITabBarItem) {
        
        i.title = "zoom " + l + " (" + String(Int(FOV / 150 * 100)) + "%)"
        var sign = l
        if sign == "-" {
            sign = "+"
        } else {
            sign = "-"
        }
        c.title = "zoom " + sign
    }
    
    func CalcFOV(type: Int) {
        
        if type == 1 {
            
            FOV -= Float(scale)
        } else {
            
            FOV += Float(scale)
        }
        
        if FOV < 0 {
            FOV = 0
        }
        if FOV > 150 {
            FOV = 150
        }
    }
}
