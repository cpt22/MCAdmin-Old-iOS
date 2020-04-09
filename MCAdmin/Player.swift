//
//  Player.swift
//  MCAdmin
//
//  Created by Christian Tingle on 4/8/20.
//  Copyright © 2020 Christian Tingle. All rights reserved.
//

import Foundation

class Player {
    // MARK: Properties
    var uuid: String
    var username: String
    var group: String
    var status: Int
    
    var APIToken: String
    
    // MARK: Init
    init(uuid: String, username: String, group: String, status: Int) {
        self.uuid = uuid
        self.username = username
        self.group = group
        self.status = status
        
        self.APIToken = (UserDefaults.standard.string(forKey: "APIToken") ?? "")
    }
    
    func kick() {
        let url = "https://www.cwru.club/api/kick.php?token=" + APIToken + "&uuid=" + uuid + "&username=" + username
        print(url)
        serverQuery(urlString: url)
    }
    
    func ban() {
        let url = "https://www.cwru.club/api/ban?token=" + APIToken + "&uuid=" + uuid + "&username=" + username
        serverQuery(urlString: url)
    }
    
    func serverQuery(urlString: String) {
        guard let myURL = URL(string: urlString) else {
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
                print(data)
                let response = self.parseJsonResponse(data: data)
                
                if (response == "success") {
                    print("success")
                } else if (response == "bad token") {
                    print("bad token")
                } else {
                }
            }
        })
        task.resume()
    }
    
    func parseJsonResponse(data: Data) -> String {
        var response = ""
        print(data)
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
            // Parse JSON data
            
            response = jsonResult?["response"] as! String
            
        } catch {
            print(error)
        }
        
        return response
    }
}
