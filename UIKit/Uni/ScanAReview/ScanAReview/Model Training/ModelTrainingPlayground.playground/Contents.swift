import CreateML
import Foundation

let jsonFilePath = "/Users/mirkobraic/Developer/ScanAReview/ScanAReview/Model Training/imdb.json"
let url = URL(fileURLWithPath: jsonFilePath)

let trainingData = try MLDataTable(contentsOf: url)

let model = try MLTextClassifier(trainingData: trainingData, textColumn: "SentimentText", labelColumn: "Sentiment")

//You can change where you want to save the model
try model.write(to: URL(fileURLWithPath: "/Users/mirkobraic/Developer/ScanAReview/ScanAReview/MLReviewModel"))
