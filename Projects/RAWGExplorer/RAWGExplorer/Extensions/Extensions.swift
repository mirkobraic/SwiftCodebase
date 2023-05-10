//
//  Extensions.swift
//  RAWGExplorer
//
//  Created by Mirko Braić on 12.03.2023..
//

import UIKit

// MARK: UITableView
extension UITableView {
    func animatedReload() {
        UIView.transition(with: self,
                          duration: 0.2,
                          options: .transitionCrossDissolve,
                          animations: { self.reloadData() },
                          completion: nil)
    }
}

// MARK: UIViewController
extension UIViewController {
    func presentAlertVC(title: String?, message: String?) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}

// MARK: UIImageView
extension UIImageView {
    func load(url: URL?) {
        guard let url else { return }
        
        DispatchQueue.global().async { [weak self] in
            guard let data = try? Data(contentsOf: url) else { return }
            guard let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                self?.image = image
            }
        }
    }
}

// MARK: String
extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        
        let attributedString = try? NSMutableAttributedString(data: data,
                                                              options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
                                                              documentAttributes: nil)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 17),
            .foregroundColor: UIColor.label
        ]

        attributedString?.addAttributes(attributes, range: NSRange(location: 0, length: attributedString?.length ?? 0))
        return attributedString
    }
}
