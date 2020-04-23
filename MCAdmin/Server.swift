//
//  Server.swift
//  MCAdmin
//
//  Created by Christian Tingle on 4/22/20.
//  Copyright © 2020 Christian Tingle. All rights reserved.
//

import Foundation

class Server {
    // MARK: Properties
    var players = [Player]()
    
    var ID: String
    var name: String
    var ip: String
    
    // MARK: Init
    init(ID: String, name: String, ip: String) {
        self.ID = ID
        self.name = name
        self.ip = ip
    }

    public func getPlayers() -> [Player] {
        return players
    }
}
