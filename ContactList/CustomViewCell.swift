//
//  CustomViewCell.swift
//  ContactList
//
//  Created by Phạm Mạnh Hà on 9/28/19.
//  Copyright © 2019 Phạm Mạnh Hà. All rights reserved.
//

import UIKit

class CustomViewCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    avatarImageView.layer.cornerRadius = 25
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.layer.borderWidth = 0.5
        avatarImageView.layer.borderColor = UIColor(red:0.38, green:0.38, blue:0.38, alpha:1.0).cgColor
        nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
