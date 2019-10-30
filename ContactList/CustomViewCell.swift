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
    nameLabel.textColor = UIColor.white
        nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
