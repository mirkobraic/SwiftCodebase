//
//  SubtitleTableViewCell.swift
//  RAWGExplorer
//
//  Created by Mirko Braić on 13.03.2023..
//

import UIKit

class SubtitleTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
