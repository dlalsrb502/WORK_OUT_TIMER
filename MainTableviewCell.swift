//
//  MainTableviewCellTableViewCell.swift
//  FirstProject
//
//  Created by 이민규 on 2021/02/27.
//

import UIKit

class MainTableviewCell: UITableViewCell {

    static let cell_id = "cell_id_lap"
    
    @IBOutlet weak var timeImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        timeLabel.text=""
    }

}
