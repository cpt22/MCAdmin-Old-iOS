//
//  PlayerDetailViewController.swift
//  MCAdmin
//
//  Created by Christian Tingle on 4/8/20.
//  Copyright © 2020 Christian Tingle. All rights reserved.
//

import UIKit

class PlayerDetailViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var uuidLabel: UILabel!
    
    @IBOutlet weak var kickButton: UIButton!
    @IBOutlet weak var banButton: UIButton!
    
    var player: Player?
        
    override func viewDidLoad() {
        super.viewDidLoad()

        if let player = player {
            self.player = player
            loadPlayer()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadPlayer), name: Notification.Name("reloadPlayerDetail"), object: nil)
    }
    
    
    
    // MARK: - Button Actions
    @IBAction func kickButtonAction(_ sender: Any) {
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to kick " + self.player!.username + "?", preferredStyle: .alert)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            self.player?.kick()
        })
        
        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
        }
        
        //Add OK and Cancel button to dialog message
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        // Present dialog message to user
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    @IBAction func banButtonAction(_ sender: Any) {
        var msg = "Are you sure you want to " + (player?.banned == 1 ? "UNBAN" : "BAN") + " " + self.player!.username
            msg += "?"
        let dialogMessage = UIAlertController(title: "Confirm", message: msg, preferredStyle: .alert)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            self.player?.ban(val: (self.player?.banned == 1 ? 0 : 1))
        })
        
        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
        }
        
        //Add OK and Cancel button to dialog message
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        // Present dialog message to user
        self.present(dialogMessage, animated: true, completion: nil)
}
    
    // MARK: Methods
    @objc func loadPlayer() {
        usernameLabel.text = self.player?.username
        uuidLabel.text = self.player?.uuid
        
        if (self.player?.status == 1) {
            kickButton.isEnabled = true
            kickButton.tintColor = UIColor.orange
        } else {
            kickButton.isEnabled = false
            kickButton.tintColor = UIColor.lightGray
        }
        
        if (player?.banned == 1) {
            banButton.setTitle("UNBAN", for: .normal)
        } else {
            banButton.setTitle("BAN", for: .normal)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
