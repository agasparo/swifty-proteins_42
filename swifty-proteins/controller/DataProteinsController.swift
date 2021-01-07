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
    
    func getPeriodicTable() -> Periodic? {
        
        let url = URL(string: "https://raw.githubusercontent.com/Bowserinator/Periodic-Table-JSON/master/PeriodicTableJSON.json")!
        
        let semaphore = DispatchSemaphore(value: 0)
        var result: Periodic?
        
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else {
                return
            }
            if let dataString = String(data: data, encoding: String.Encoding.utf8) {
                do {
                    let jsonData = dataString.data(using: .utf8)!
                    print (jsonData)
                    result = try JSONDecoder().decode(Periodic.self, from: jsonData)
                    semaphore.signal()
                    return
                } catch {
                    semaphore.signal()
                    return
                }
            }
        }.resume()
        semaphore.wait()
        return result
    }
}
