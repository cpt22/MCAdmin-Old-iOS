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
    var server: Server
    
    // Bans
    var banned: Int
    var banExecutor: String
    
    var loginToken: String
    
    // MARK: Init
    init(uuid: String, username: String, group: String, status: Int, server: Server, banned: Int, banExecutor: String) {
        self.uuid = uuid
        self.username = username
        self.group = group
        self.status = status
        self.server = server
        
        self.banned = banned
        self.banExecutor = banExecutor
        
        self.loginToken = (UserDefaults.standard.string(forKey: "loginToken") ?? "")
    }
    
    func kick() {
        let url = "https://www.mcadmin.xyz/api/admin/kick?token=" + loginToken + "&uuid=" + uuid + "&username=" + username + "&sID=" + server.ID
        serverQuery(urlString: url)
        print(url)
    }
    
    func ban(val: Int) {
        let url = "https://www.mcadmin.xyz/api/admin/ban?token=" + loginToken + "&uuid=" + uuid + "&username="  + username + "&sID=" + server.ID + "&value=" + String(val)
        serverQuery(urlString: url)
    }
    
    func update() {
        let urlString = "https://www.mcadmin.xyz/api/admin/updatePlayer?token=" + loginToken + "&uuid=" + uuid + "&sID=" + server.ID
        
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

                let response = self.parseJsonPlayer(data: data)
                
                if (response == "success") {
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: Notification.Name("reloadPlayerDetail"), object: nil)
                    }
                } else if (response == "bad token") {
                } else {
                }
            }
        })
        task.resume()
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

                let response = self.parseJsonResponse(data: data)
            
                if (response == "success") {
                    sleep(1)
                    self.update()
                } else if (response == "bad token") {
                } else {
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
    
    
    func parseJsonPlayer(data: Data) -> String {
        var response = ""
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
            // Parse JSON data
            let jsonPlayers = jsonResult?["players"] as! [AnyObject]
            for jsonPlayer in jsonPlayers {
                self.uuid = jsonPlayer["uuid"] as! String
                self.username = jsonPlayer["username"] as! String
                self.status = jsonPlayer["status"] as! Int
                self.group = jsonPlayer["primary_group"] as! String
                
                self.banned = jsonPlayer["banned"] as! Int
                self.banExecutor = jsonPlayer["executor"] as! String
            }
    
            response = jsonResult?["response"] as! String
        } catch {
            print(error)
        }
        return response

    }
}
