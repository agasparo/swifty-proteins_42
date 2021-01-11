//
//  ProteinsModel.swift
//  swifty-proteins
//
//  Created by arthur on 05/01/2021.
//

import UIKit

class ProteinsModel {
    
    let radius:Float = 0.3
    
    func GetColor(atom: String, periodic: Periodic?) -> UIColor {
        
        var i = 0
        while (i < (periodic?.elements!.count)!) {
            
            if periodic?.elements![i].symbol == atom {
                
                let color = (periodic?.elements![i].cpk!)!
                return UIColor(color)
            }
            i += 1
        }
        
        return (UIColor.white)
    }
    
    func GetRadius() -> Float {
        
        return (radius)
    }
    
    func GetCylinderRadius() -> Float {
        
        return (0.05)
    }
}
