//
//  User.swift
//  MCAdmin
//
//  Created by Christian Tingle on 4/22/20.
//  Copyright © 2020 Christian Tingle. All rights reserved.
//

import Foundation

class User {
    
    enum Permission {
        case BAN
        case UNBAN
        case KICK
        case SENDMESSAGE
    }
    
    var username: String
    var loginToken: String
    
    var permissions = [Permission]()
    
    init (loginToken: String, username: String, permissions: [String]) {
        self.loginToken = loginToken
        self.username = username

        for permission in permissions {
            switch (permission) {
            case "mcadmin.sendmessage":
                self.permissions.append(Permission.SENDMESSAGE)
                break
            case "mcadmin.ban":
                self.permissions.append(Permission.BAN)
                break
            case "mcadmin.unban":
                self.permissions.append(Permission.UNBAN)
                break
            case "mcadmin.kick":
                self.permissions.append(Permission.KICK)
                break
            default:
                break
            }
        }
    }
    
    public func hasPermission(permission: Permission) -> Bool {
        return permissions.contains(permission)
    }
}
