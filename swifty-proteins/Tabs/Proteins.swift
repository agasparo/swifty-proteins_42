//
//  Proteins.swift
//  swifty-proteins
//
//  Created by arthur on 04/01/2021.
//

import UIKit

class ProteinsTab : UITableViewController, UISearchResultsUpdating {
    
    var data: [String.SubSequence]?
    var filteredTableData = [String.SubSequence]()
    var resultSearchController = UISearchController()
    var histoProt = [""] // le mettre en persistant
    var Data = DataProteins()
    
    override func viewDidLoad() {
            
        super.viewDidLoad()

        let response_data = ChoiceController().GetProteins()
        if !response_data.isEmpty {
                data = response_data
        }
        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.searchBar.sizeToFit()
            controller.obscuresBackgroundDuringPresentation = false
            controller.searchBar.placeholder = "Search Proteins"
                
            tableView.tableHeaderView = controller.searchBar
                
            return controller
        })()
            
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        filteredTableData.removeAll(keepingCapacity: false)
                
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (self.data! as NSArray).filtered(using: searchPredicate)
                filteredTableData = array as! [String.SubSequence]
        if searchController.searchBar.text!.isEmpty {
            filteredTableData = self.data!
        }
        self.tableView.reloadData()
    }
 
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if  (resultSearchController.isActive) {
            
            return filteredTableData.count
        } else {
            
            return self.data!.count
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProtCells", for: indexPath) as! ProteinsCustomCell
                
        if (resultSearchController.isActive) {

            cell.Name.text = String(filteredTableData[indexPath.row])
            if histoProt.contains(cell.Name.text!) {
                cell.State.text = "already seen"
                cell.State.textColor = UIColor(red: 0, green: 0.2863, blue: 0.149, alpha: 1.0)
            } else {
                cell.State.text = "not see"
                cell.State.textColor = .gray
            }
        } else {

            cell.Name.text = String(self.data![indexPath.row])
            if histoProt.contains(cell.Name.text!) {
                cell.State.text = "already seen"
                cell.State.textColor = UIColor(red: 0, green: 0.2863, blue: 0.149, alpha: 1.0)
            } else {
                cell.State.text = "not see"
                cell.State.textColor = .gray
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var name: String
        
        if (resultSearchController.isActive) {
            
            name = String(filteredTableData[indexPath.row])
        } else {
            
            name = String(self.data![indexPath.row])
        }
        
        let tableElems = Data.getPeriodicTable()
        
        //ici speening wheel
        self.histoProt.append(name)
        let response = Data.getPdbFile(name: name)
        if !response.isEmpty && tableElems != nil {
         
            let main = UIStoryboard(name: "Main", bundle: nil)
            if let next = main.instantiateViewController(withIdentifier: "Model") as? ProteinsViewController {
                
                next.dataRepresent = response
                next.periodicValue = tableElems
                next.ProtIdValue = name
                self.present(next, animated: true, completion: { () in
                
                    print ("stop sinnig")
                })
            }
        } else {
            
            self.present(self.UIErrors(titlePopUp: "Error", msg: "No data found for " + name, response: "ok"), animated: true)
        }
    }
    
    func UIErrors(titlePopUp: String, msg: String, response: String) -> UIAlertController {
        
        let ac = UIAlertController(title: titlePopUp, message: msg, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: response, style: .default))
        return ac
    }
    
}
