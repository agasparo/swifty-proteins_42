//
//  ProteinsModel.swift
//  swifty-proteins
//
//  Created by arthur on 05/01/2021.
//

import UIKit

class ProteinsModel {
    
    let radius:Float = 0.3
    
    func GetColor(atom: String) -> UIColor {
        
        switch atom {
        case "H":
            return .white
        case "C":
            return .black
        case "N":
            return .blue
        case "O":
            return .red
        case "F":
            return .green
        case "I":
            return .magenta
        case "Br":
            return UIColor(red: 127/255, green: 0/255, blue: 19/255, alpha: 1.0)
        case "S":
            return .yellow
        case "Cl":
            return .green
        default:
            return UIColor(red: 227/255, green: 0/255, blue: 239/255, alpha: 1.0)
        }
    }
    
    func GetRadius() -> Float {
        
        return (radius)
    }
    
    func GetCylinderRadius() -> Float {
        
        return (0.05)
    }
}
