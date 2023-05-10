//
//  BusinessCardTableViewCell.swift
//  Conf++
//
//  Created by Tomislav Jurić-Arambašić on 14.02.2022..
//

import UIKit

class BusinessCardTableViewCell: UITableViewCell {
    @IBOutlet var backView: UIView!
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var halfCircleView: UIView!
    @IBOutlet var websiteTextView: UITextView!
    @IBOutlet var phoneTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        halfCircleView.layer.cornerRadius = 140
    }    
}
