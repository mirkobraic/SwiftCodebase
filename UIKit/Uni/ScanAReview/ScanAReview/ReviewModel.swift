//
//  ReviewModel.swift
//  ScanAReview
//
//  Created by Mirko Braic on 22/01/2021.
//

import UIKit

struct ReviewModel {
    var text: String
    var color: UIColor
    var sentiment: String
    
    init(text: String, color: UIColor, sentiment: String) {
        self.text = text
        self.color = color
        self.sentiment = sentiment
    }
}

