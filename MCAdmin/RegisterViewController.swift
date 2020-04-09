//
//  RegisterViewController.swift
//  MCAdmin
//
//  Created by Christian Tingle on 4/5/20.
//  Copyright © 2020 Christian Tingle. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    private let queryURL = "https://www.cwru.club/api/verifyToken?token="
    private var token: String?
    let current = UNUserNotificationCenter.current()
    //var webResponse = ""
    @IBOutlet weak var appTokenField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        token = (UserDefaults.standard.string(forKey: "APIToken") ?? "")
        if (token != "") {
            queryRegister(token: token!)
        }
    }
    
    @IBAction func tryRegister(_ sender: Any) {
        let token = appTokenField.text ?? ""
        if (token != "") {
            queryRegister(token: token)
        }
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
                let webResponse = self.parseJsonResponse(data: data)
                
                if (webResponse == "success") {
                    let deviceID = (UserDefaults.standard.string(forKey: "APNSToken") ?? "")
                    
                    self.current.getNotificationSettings(completionHandler: { (settings) in
                        if settings.authorizationStatus == .notDetermined {
                            // Notification permission has not been asked yet, go for it!
                        } else if settings.authorizationStatus == .denied {
                            self.updateNotificationsInDB(APIToken: token, deviceID: deviceID, currentStatus: 0)
                        } else if settings.authorizationStatus == .authorized {
                            self.updateNotificationsInDB(APIToken: token, deviceID: deviceID, currentStatus: 1)
                        }
                    })
                    
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(token, forKey: "APIToken")
                        self.performSegue(withIdentifier: "loginSegue", sender: nil)
                    }
                } else if (webResponse == "bad token") {
                    DispatchQueue.main.async {
                        UserDefaults.standard.set("", forKey: "APIToken")
                        
                        let dialogMessage = UIAlertController(title: "Notice", message: "Invalid Token", preferredStyle: .alert)
                        
                        // Create OK button with action handler
                        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                        })
                        
                        //Add OK and Cancel button to dialog message
                        dialogMessage.addAction(ok)
                        
                        // Present dialog message to user
                        self.present(dialogMessage, animated: true, completion: nil)
                    }
                }
            }
        })
        task.resume()
    }
    
    func updateNotificationsInDB(APIToken: String, deviceID: String, currentStatus: Int) {
        var url = "https://www.cwru.club/api/updateNotificationPrefs?token=" + APIToken + "&device="
        url += deviceID + "&status=" + String(currentStatus)
        
        print(url)
        
        guard let myURL = URL(string: url) else {
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
                let webResponse = self.parseJsonResponse(data: data)
                
                if (webResponse == "success") {
                    print("updated DB")
                } else if (webResponse == "bad token") {
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
