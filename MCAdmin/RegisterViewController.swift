//
//  RegisterViewController.swift
//  MCAdmin
//
//  Created by Christian Tingle on 4/5/20.
//  Copyright © 2020 Christian Tingle. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    private let queryURL = "https://www.cwru.club/api/verifyToken.php?token="
    private var tkn = ""
    var bigResponse = ""
    @IBOutlet weak var appTokenField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tkn = (UserDefaults.standard.string(forKey: "APIToken") ?? "")
        queryRegister(token: tkn)
    }
    
    @IBAction func tryRegister(_ sender: Any) {
        let token = appTokenField.text ?? ""
        queryRegister(token: token)
    }
    
    func queryRegister(token: String) {
        guard let myURL = URL(string: queryURL + token) else {
            return
        }
        
        let request = URLRequest(url: myURL)
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            
            if let error = error {
                print(error)
                return
            }
            // Parse JSON data
            if let data = data {
                let bigResponse = self.parseJsonResponse(data: data)
                
                if (bigResponse == "success") {
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(token, forKey: "APIToken")
                        self.performSegue(withIdentifier: "loginSegue", sender: nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        //UserDefaults.standard.set("", forKey: "APIToken")
                        //performSegue(withIdentifier: "loginSegue", sender: nil)
                    }
                }
            }
        })
        task.resume()
    }
    
    func parseJsonResponse(data: Data) -> String {
        var response = ""
        
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
            // Parse JSON data
            response = jsonResult?["response"] as! String
            
        } catch {
            print(error)
        }
        
        return response
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
}
