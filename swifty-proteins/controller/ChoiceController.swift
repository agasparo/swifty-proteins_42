//
//  ChoiceController.swift
//  swifty-proteins
//
//  Created by arthur on 04/01/2021.
//

import UIKit

class ChoiceController {

    let ProteinsUrl = "https://projects.intra.42.fr/uploads/document/document/2080/ligands.txt"
    
    func GetProteins() -> [String.SubSequence] {
        
        let url = URL(string: ProteinsUrl)!
        
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
