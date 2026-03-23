//
//  CommonComponentsManager.swift
//  MySampleTEsts
//
//  Created by Vic on 13/10/2025.
//

import SwiftUI
import UIKit

@MainActor
class CommonComponentsManager {
    static let shared = CommonComponentsManager()
    
    private let bundle = Bundle.main
    
    private init() {}


    func image(named name: String) -> Image {
        let imagePath = "CommonComponents/\(name)"
        
        guard let path = bundle.path(forResource: imagePath, ofType: nil) else {
            print("⚠️ Image not found at path: CommonComponents/Images/\(name)")
            return Image(systemName: "photo") // fallback
        }
        
        guard let uiImage = UIImage(contentsOfFile: path) else {
            print("⚠️ Failed to create UIImage from path: \(path)")
            return Image(systemName: "photo")
        }
        
        return Image(uiImage: uiImage)
    }

    // MARK: - Load Video URL from CommonComponents/Videos/ (optional)

    func videoURL(named name: String) -> URL? {
        let videoPath = "CommonComponents/\(name)"
//        return bundle.url(forResource: videoPath, withExtension: nil)
        return bundle.bundleURL.appendingPathComponent(videoPath)
    }
}
