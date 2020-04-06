//
//  PlayerTableViewCell.swift
//  MCAdmin
//
//  Created by Christian Tingle on 4/5/20.
//  Copyright © 2020 Christian Tingle. All rights reserved.
//

import UIKit

class PlayerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var usernameLabel:UILabel! {
        didSet {
            usernameLabel.numberOfLines = 1
        }
    }
    @IBOutlet weak var uuidLabel:UILabel! {
        didSet {
            uuidLabel.numberOfLines = 1
        }
    }
    @IBOutlet weak var groupLabel:UILabel! {
        didSet {
            groupLabel.numberOfLines = 1
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
