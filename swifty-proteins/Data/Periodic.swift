//
//  Periodic.swift
//  swifty-proteins
//
//  Created by arthur on 07/01/2021.
//

import Foundation

struct Periodic: Codable {
    
    let elements: [AtomDetail]?
}

struct AtomDetail : Codable {
    
    let name, discovered_by, symbol, cpk: String?
    let molar_heat, density, atomic_mass: Float?
    
    enum CodingKeys: String, CodingKey {
        
        case name = "name"
        case discovered_by = "discovered_by"
        case symbol = "symbol"
        case cpk = "cpk-hex"
        
        case molar_heat = "molar_heat"
        case density = "density"
        case atomic_mass = "atomic_mass"
    }
}
