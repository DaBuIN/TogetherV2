//
//  applyGroupTBVCell.swift
//  together
//
//  Created by Seven Tsai on 2017/7/31.
//  Copyright © 2017年 Seven Tsai. All rights reserved.
//

import UIKit

class applyGroupTBVCell: UITableViewCell {
    @IBOutlet weak var labelCell: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    
    @IBOutlet weak var imgSubjectPic: UIImageView!
    
    @IBOutlet weak var labelNumber: UILabel!
    
    @IBOutlet weak var labelDetail: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
