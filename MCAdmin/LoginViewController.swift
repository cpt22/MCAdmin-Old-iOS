//
//  RegisterViewController.swift
//  MCAdmin
//
//  Created by Christian Tingle on 4/5/20.
//  Copyright © 2020 Christian Tingle. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    struct WebResponse {
        var status: String?
        var token: String?
        var errors: [String]?
        var values: [String]?
    }
    
    private var validateURL = "https://www.mcadmin.xyz/api/user/validate.php?token="
    private var loginURL = "https://www.mcadmin.xyz/api/user/login.php?username="
    private var token: String?
    
    private var user: User?
    
    let current = UNUserNotificationCenter.current()

    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        token = (UserDefaults.standard.string(forKey: "loginToken") ?? "")

        if (token != "") {
            queryAutoLogin(token: token!)
        }
    }
    
    @IBAction func doLogin(_ sender: Any) {
        let username = usernameField.text ?? ""
        let password = passwordField.text ?? ""
        if (username != "" && password != "") {
            queryLogin(username: username, password: password)
        }
    }
    
    func queryLogin(username: String, password: String) {
        guard let myURL = URL(string: loginURL + username + "&password=" + password) else {
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
                let resp = self.parseJsonResponse(data: data)
                
                if (resp.status == "success") {
                    let deviceID = (UserDefaults.standard.string(forKey: "APNSToken") ?? "")
                    
                    self.current.getNotificationSettings(completionHandler: { (settings) in
                        if settings.authorizationStatus == .notDetermined {
                            // Notification permission has not been asked yet, go for it!
                        } else if settings.authorizationStatus == .denied {
                            self.updateNotificationsInDB(token: resp.token!, deviceID: deviceID, currentStatus: 0)
                        } else if settings.authorizationStatus == .authorized {
                            self.updateNotificationsInDB(token: resp.token!, deviceID: deviceID, currentStatus: 1)
                        }
                    })
                    
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(resp.token, forKey: "loginToken")
                        self.performSegue(withIdentifier: "loginSegue", sender: nil)
                    }
                } else if (resp.status == "failure") {
                    
                    
                    DispatchQueue.main.async {
                        self.passwordField.text = ""
                        self.usernameField.text = resp.values?[0] ?? ""
                        
                        UserDefaults.standard.set("", forKey: "loginToken")
                        
                        let dialogMessage = UIAlertController(title: "Notice", message: "Login Invalid", preferredStyle: .alert)
                        
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
    
    func queryAutoLogin(token: String) {
        guard let myURL = URL(string: validateURL + token) else {
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
                let resp = self.parseJsonResponse(data: data)
                print(resp)
                if (resp.status == "success") {
                    let deviceID = (UserDefaults.standard.string(forKey: "APNSToken") ?? "")
                    
                    self.current.getNotificationSettings(completionHandler: { (settings) in
                        if settings.authorizationStatus == .notDetermined {
                            // Notification permission has not been asked yet, go for it!
                        } else if settings.authorizationStatus == .denied {
                            self.updateNotificationsInDB(token: resp.token ?? "", deviceID: deviceID, currentStatus: 0)
                        } else if settings.authorizationStatus == .authorized {
                            self.updateNotificationsInDB(token: resp.token ?? "", deviceID: deviceID, currentStatus: 1)
                        }
                    })
                    
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(resp.token, forKey: "loginToken")
                        self.performSegue(withIdentifier: "loginSegue", sender: nil)
                    }
                } else if (resp.status == "failure") {
                    DispatchQueue.main.async {
                        UserDefaults.standard.set("", forKey: "loginToken")
                        
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
    
    func updateNotificationsInDB(token: String, deviceID: String, currentStatus: Int) {
        var url = "https://www.mcadmin.xyz/api/client/updateNotificationPrefs?token=" + token + "&device="
        url += deviceID + "&status=" + String(currentStatus)

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
                /*let webResponse = self.parseJsonResponse(data: data)
                
                if (webResponse == "success") {
                } else if (webResponse == "bad token") {
                }*/
            }
        })
        task.resume()
    }
    
    func parseJsonResponse(data: Data) -> WebResponse {
        var resp = WebResponse()
        
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
            // Parse JSON data
                        
            resp.status = jsonResult?["status"] as? String
            resp.token = jsonResult?["token"] as? String
            resp.errors = jsonResult?["errors"] as? [String]
            resp.values = jsonResult?["values"] as? [String]
            if (resp.status == "success") {
                let perms = jsonResult?["permissions"] as? [String]
                let username = jsonResult?["username"] as? String
                user = User(loginToken: resp.token ?? "", username: username ?? "", permissions: perms ?? [String]())
            }
            
        } catch {
            print(error)
        }
        
        return resp
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
        case "loginSegue":
            guard let playerTableViewController = segue.destination as? PlayerTableViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            playerTableViewController.setUser(user: user!)
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}
