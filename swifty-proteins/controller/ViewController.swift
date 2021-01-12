//
//  ViewController.swift
//  swifty-proteins
//
//  Created by arthur on 04/01/2021.
//

import UIKit
import LocalAuthentication

class LoginController: UIViewController {

    @IBOutlet weak var TouchIDBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.jpg")!)
        
        let context = LAContext()
        var error : NSError?
        
        if !context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            
            TouchIDBtn.isHidden = true
        }
    }
    
    @IBAction func TouchIdAuthenticate(_ sender: Any) {
        
        let context = LAContext()
        var error : NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            
            let reason = "Identify yourself !"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [unowned self] success, authenticationError in
                
                DispatchQueue.main.async {
                    
                    if success {
                        
                        let main = UIStoryboard(name: "Main", bundle: nil)
                        let next = main.instantiateViewController(withIdentifier: "Choose")
                        self.present(next, animated: true, completion: nil)
                    } else {
                        
                        self.present(self.UIErrors(titlePopUp: "Error", msg: "Authentication failed", response: "ok"), animated: true)
                    }
                }
            }
        } else {
            
            self.present(self.UIErrors(titlePopUp: "Error", msg: "No biometric system found", response: "ok"), animated: true)
        }
    }
    
    func UIErrors(titlePopUp: String, msg: String, response: String) -> UIAlertController {
        
        let ac = UIAlertController(title: titlePopUp, message: msg, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: response, style: .default))
        return ac
    }
}

