//
//  LocalFileManager.swift
//  SwiftfulCrypto
//
//  Created by Mirko Braic on 25.07.2023..
//

import Foundation
import SwiftUI

class LocalFileManager {
    static let shared = LocalFileManager()
    private init() { }

    func saveImage(image: UIImage, imageName: String, folderName: String) {
        createFolderIfNeeded(folderName: folderName)

        guard let data = image.pngData(),
              let url = getUrlFor(imageName: imageName, folderName: folderName)
        else { return }

        do {
            try data.write(to: url)
        } catch let error {
            print("Error saving image: \(error)")
        }
    }

    func getImage(imageName: String, folderName: String) -> UIImage? {
        guard let url = getUrlFor(imageName: imageName, folderName: folderName) else { return nil }
        return UIImage(contentsOfFile: url.path)

    }

    private func createFolderIfNeeded(folderName: String) {
        let url = URL.cachesDirectory.appendingPathComponent(folderName)
        if FileManager.default.fileExists(atPath: url.path) == false {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
            } catch let error {
                print("Error creating direcotry. FolderName: \(folderName). \(error)")
            }
        }
    }

    private func getUrlFor(imageName: String, folderName: String) -> URL? {
        return URL.cachesDirectory.appendingPathComponent(folderName).appendingPathComponent(imageName + ".png")
    }
}
