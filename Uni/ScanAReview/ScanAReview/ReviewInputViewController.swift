//
//  ReviewInputViewController.swift
//  ScanAReview
//
//  Created by Mirko Braic on 22/01/2021.
//

import UIKit

class ReviewInputViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    
    var saveReviewCallback: ((String) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.becomeFirstResponder()
    }
    
    @IBAction func doneTapped(_ sender: UIBarButtonItem) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false {
            saveReviewCallback?(textView.text)
        }
        dismiss(animated: true)
    }
}
