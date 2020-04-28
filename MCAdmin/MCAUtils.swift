//
//  JSONUtils.swift
//  MCAdmin
//
//  Created by Christian Tingle on 4/27/20.
//  Copyright © 2020 Christian Tingle. All rights reserved.
//

import Foundation

class MCAUtils {
    
    static func processJSONServers(jsonServers: [AnyObject]) -> [Server] {
        var servers = [Server]()
        for jsonServer in jsonServers {
            servers.append(MCAUtils.processJSONServer(jsonServer: jsonServer))
        }
        return servers
    }
    
    static func processJSONServer(jsonServer: AnyObject) -> Server {
        let ID = jsonServer["ID"] as! String
        let name = jsonServer["name"] as! String
        let ip = jsonServer["ip"] as! String
        let server = Server(ID: ID, name: name, ip: ip)
        
        let jsonPlayers = jsonServer["players"] as! [AnyObject]
        server.players = MCAUtils.processJSONPlayers(jsonPlayers: jsonPlayers, server: server)
        
        return server
    }
    
    /*
     
     */
    static func processJSONPlayers(jsonPlayers: [AnyObject], server: Server) -> [Player] {
        var players = [Player]()
        for jsonPlayer in jsonPlayers {
            players.append(MCAUtils.processJSONPlayer(jsonPlayer: jsonPlayer, server: server))
        }
        return players
    }
    
    static func processJSONPlayer(jsonPlayer: AnyObject, server: Server) -> Player {
        let uuid = jsonPlayer["uuid"] as! String
        let username = jsonPlayer["username"] as! String
        let status = jsonPlayer["status"] as! Int
        let timeOffline = jsonPlayer["timeOffline"] as! String
        let banned = jsonPlayer["banned"] as! Bool
        let banExecutor = jsonPlayer["executor"] as! String
        
        return Player(uuid: uuid, username: username, status: status, server: server, timeOffline: timeOffline, banned: banned, banExecutor: banExecutor);
    }
}
