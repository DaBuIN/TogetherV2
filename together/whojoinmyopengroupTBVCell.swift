//
//  whojoinmyopengroupTBVCell.swift
//  together
//
//  Created by Seven Tsai on 2017/8/10.
//  Copyright © 2017年 Seven Tsai. All rights reserved.
//

import UIKit

class whojoinmyopengroupTBVCell: UITableViewCell {
    @IBOutlet weak var imgUserPhoto: UIImageView!

    @IBOutlet weak var labelCell: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    
    @IBOutlet weak var starttime: UILabel!
    
    @IBOutlet weak var endtime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    


}
