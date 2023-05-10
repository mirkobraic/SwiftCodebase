//
//  ViewController.swift
//  ScanAReview
//
//  Created by Mirko Braic on 21/01/2021.
//

import UIKit
import CoreML
import VisionKit
import Vision

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataSource: [ReviewModel] = []
    
    
    private var ocrRequest = VNRecognizeTextRequest(completionHandler: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let size = NSCollectionLayoutSize(
            widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
            heightDimension: NSCollectionLayoutDimension.estimated(44)
        )
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        section.interGroupSpacing = 10

        let layout = UICollectionViewCompositionalLayout(section: section)
        collectionView.collectionViewLayout = layout
        
        configureOCR()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination.children.first as? ReviewInputViewController {
            destination.saveReviewCallback = { [weak self] reviewText in
                guard let self = self else { return }
                self.addReview(withText: reviewText)
            }
        }
    }
    
    func addReview(withText text: String) {
        do {
            let mlModel = try MLReviewModel(configuration: MLModelConfiguration())
            let prediction = try mlModel.prediction(text: text)
            let model: ReviewModel
            if prediction.label == "Positive" {
                model = ReviewModel(text: text, color: .systemGreen, sentiment: prediction.label)
            } else {
                model = ReviewModel(text: text, color: .systemRed, sentiment: prediction.label)
            }
            dataSource.append(model)
            let index = IndexPath(item: dataSource.endIndex - 1, section: 0)
            collectionView.insertItems(at: [index])
            collectionView.scrollToItem(at: index, at: .bottom, animated: true)
        } catch {
            print(error)
        }
    }
    
    private func configureOCR() {
        ocrRequest = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            
            var ocrText = ""
            for observation in observations {
                guard let topCandidate = observation.topCandidates(1).first else { return }
                
                ocrText += topCandidate.string + "\n"
            }
            
            DispatchQueue.main.async {
                self.addReview(withText: ocrText)
            }
        }
        
        ocrRequest.recognitionLevel = .accurate
        ocrRequest.recognitionLanguages = ["en-US", "en-GB"]
        ocrRequest.usesLanguageCorrection = true
    }
    
    private func processImage(_ image: UIImage) {
        guard let cgImage = image.cgImage else { return }
            
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try requestHandler.perform([ocrRequest])
        } catch let error {
            print(error)
        }
    }
    
    @IBAction func cameraButtonTapped(_ sender: UIBarButtonItem) {
        let scanVC = VNDocumentCameraViewController()
        scanVC.delegate = self
        present(scanVC, animated: true)
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reviewCell", for: indexPath) as! ReviewCollectionViewCell
        
        let review = dataSource[indexPath.row]
        cell.sentiment.text = review.sentiment
        cell.text.text = review.text
        cell.contentView.layer.borderColor = review.color.cgColor
        cell.cornerColor = review.color
        
        return cell
    }
}

extension ViewController: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        guard scan.pageCount >= 1 else {
            controller.dismiss(animated: true)
            return
        }
        for pageIndex in 0 ..< scan.pageCount {
            processImage(scan.imageOfPage(at: pageIndex))
        }
        controller.dismiss(animated: true)
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        //Handle properly error
        controller.dismiss(animated: true)
    }
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true)
    }
}
