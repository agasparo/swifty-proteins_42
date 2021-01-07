//
//  mendeleievModel.swift
//  swifty-proteins
//
//  Created by arthur on 07/01/2021.
//

import UIKit


class MendeleievModel: NSObject {
    
    var Table: Periodic?
    
    func setup(data: Periodic?) {
        
        Table = data
    }
    
    func getAtomsBySymbol(name: String) -> AtomDetail? {
        
        var i:Int = 0
        
        while (i < (Table?.elements!.count)!) {
            
            if Table?.elements![i].symbol == name {
                
                return Table?.elements![i]
            }
            i += 1
        }
        return nil
    }
}
