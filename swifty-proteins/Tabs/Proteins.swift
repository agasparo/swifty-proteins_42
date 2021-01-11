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
    static var histoProt = [String]()
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
            if ProteinsTab.histoProt.contains(cell.Name.text!) {
                cell.State.text = "already seen"
                cell.State.textColor = UIColor(red: 0, green: 0.2863, blue: 0.149, alpha: 1.0)
            } else {
                cell.State.text = "not see"
                cell.State.textColor = .gray
            }
        } else {

            cell.Name.text = String(self.data![indexPath.row])
            if ProteinsTab.histoProt.contains(cell.Name.text!) {
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
        
        self.resultSearchController.searchBar.text = ""
        resultSearchController.dismiss(animated: false, completion: { () in
                
            let alert = self.ShowSpinner()
            
            let tableElems = self.Data.getPeriodicTable()
            ProteinsTab.histoProt.append(name)
            let response = self.Data.getPdbFile(name: name)
            if !response.isEmpty && tableElems != nil {
             
                let main = UIStoryboard(name: "Main", bundle: nil)
                if let next = main.instantiateViewController(withIdentifier: "Model") as? ProteinsViewController {
                    
                    next.dataRepresent = response
                    next.periodicValue = tableElems
                    next.ProtIdValue = name
                    
                    alert.dismiss(animated: false, completion: {() in
                        
                        tableView.reloadData()
                        self.present(next, animated: true, completion: nil)
                    })
                }
            } else {
                
                self.present(self.UIErrors(titlePopUp: "Error", msg: "No data found for " + name, response: "ok"), animated: true)
            }
        })
    }
    
    func UIErrors(titlePopUp: String, msg: String, response: String) -> UIAlertController {
        
        let ac = UIAlertController(title: titlePopUp, message: msg, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: response, style: .default))
        return ac
    }
    
    func ShowSpinner() -> UIAlertController {
        
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        return (alert)
    }
}
