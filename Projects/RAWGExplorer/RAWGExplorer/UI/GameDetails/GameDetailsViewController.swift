//
//  GameDetailsViewController.swift
//  RAWGExplorer
//
//  Created by Mirko Braić on 12.03.2023..
//

import UIKit

class GameDetailsViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var gameId: Int
    var gameDetails: GameDetails?
    
    init(gameId: Int) {
        self.gameId = gameId
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageViewHeightConstraint.constant = imageView.frame.height
        scrollView.delegate = self
        fetchGameDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    private func fetchGameDetails() {
        if let gameDetails = CacheManager.shared.getGameDetails(forId: gameId) {
            self.gameDetails = gameDetails
            setupViews()
        } else {
            NetworkManager.shared.fetchGameDetails(forId: gameId) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let gameDetails):
                        self.gameDetails = gameDetails
                        self.setupViews()
                        CacheManager.shared.setGameDetails(gameDetails)
                    case .failure:
                        self.presentAlertVC(title: "Error", message: "Unable to fetch game details")
                    }
                }
            }
        }
    }

    private func setupViews() {
        guard let gameDetails else { return }
        
        titleLabel.text = gameDetails.name
        releaseDateLabel.text = gameDetails.releaseDate
        descriptionLabel.attributedText = gameDetails.description.htmlToAttributedString
        
        if let image = gameDetails.backgroundImage {
            imageView.image = image
        } else {
            NetworkManager.shared.fetchImageFrom(urlString: gameDetails.backgroundImageUrlString, completion: { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let image):
                        self.gameDetails?.backgroundImage = image
                        self.imageView.image = image
                    case .failure:
                        break
                    }
                }
            })
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: UIGestureRecognizerDelegate
extension GameDetailsViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: UIScrollViewDelegate
extension GameDetailsViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        
        if offset.y < 0.0 {
            var transform = CATransform3DTranslate(CATransform3DIdentity, 0, offset.y, 0)
            let scaleFactor = 1 + (-offset.y / (imageViewHeightConstraint.constant / 2))
            transform = CATransform3DScale(transform, scaleFactor, scaleFactor, 1)
            imageView.layer.transform = transform
        } else {
            imageView.layer.transform = CATransform3DIdentity
        }
    }
}
