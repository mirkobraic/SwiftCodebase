//
//  ReviewCollectionViewCell.swift
//  ScanAReview
//
//  Created by Mirko Braic on 21/01/2021.
//

import UIKit

class ReviewCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var sentiment: UILabel!
    @IBOutlet weak var text: UILabel!
    
    var cornerColor: UIColor?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        roundCorner()
        setCellShadow()
    }

//    override var isHighlighted: Bool {
//        didSet {
//            UIView.animate(withDuration: 0.27, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 1.0, options: [.curveEaseOut, .beginFromCurrentState]) {
//                self.contentView.alpha = self.isHighlighted ? 0.35 : 1
//                self.transform = self.isHighlighted ? self.transform.scaledBy(x: 0.96, y: 0.96) : .identity
//            }
//        }
//    }
    
//    override var isSelected: Bool {
//        didSet {
//            if isSelected {
//                contentView.layer.borderColor = UIColor.gray.cgColor
//                contentView.backgroundColor = .lightGray
//            } else {
//                contentView.layer.borderColor = cornerColor?.cgColor
//                contentView.backgroundColor = .white
//            }
//        }
//    }
    
    func setCellShadow() {
        layer.shadowColor = UIColor.secondaryLabel.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 4
        layer.masksToBounds = false
        layer.cornerRadius = 10
        clipsToBounds = false
    }
    
    func roundCorner() {
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = cornerColor?.cgColor
    }
}
