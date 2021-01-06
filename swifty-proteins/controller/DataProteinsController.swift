//
//  DataProteinsController.swift
//  swifty-proteins
//
//  Created by arthur on 05/01/2021.
//

import Foundation

class DataProteins {
    
    func getPdbFile(name: String) -> [String.SubSequence] {
        
        let url = URL(string: "https://files.rcsb.org/ligands/view/" + name + "_ideal.pdb")!
        
        let semaphore = DispatchSemaphore(value: 0)
        var result: [String.SubSequence]?
        
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else {
                return
            }
            let response = String(data: data, encoding: .utf8)!
            let lines = response.split(whereSeparator: \.isNewline)
            if lines.count > 0 {
                
                result = lines
                semaphore.signal()
                return
            }
        }.resume()
        semaphore.wait()
        return result!
    }
}
