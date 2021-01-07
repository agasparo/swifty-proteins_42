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
    
    let name, discovered_by: String?
    let molar_heat, density, atomic_mass: Float?
}
