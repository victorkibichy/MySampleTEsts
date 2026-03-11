//
//  CommonComponentsManager.swift
//  MySampleTEsts
//
//  Created by Vic on 13/10/2025.
//

import SwiftUI
import UIKit // Required for UIImage

@MainActor
class CommonComponentsManager {
    static let shared = CommonComponentsManager()
    
    private let bundle = Bundle.main
    
    private init() {}

    // MARK: - Load Image from CommonComponents/Images/

    func image(named name: String) -> Image {
        // Construct full relative path
        let imagePath = "CommonComponents/Images/\(name)"
        
        // Get full file path in app bundle
        guard let path = bundle.path(forResource: imagePath, ofType: nil) else {
            print("⚠️ Image not found at path: CommonComponents/Images/\(name)")
            return Image(systemName: "photo") // fallback
        }
        
        // Load UIImage from file path
        guard let uiImage = UIImage(contentsOfFile: path) else {
            print("⚠️ Failed to create UIImage from path: \(path)")
            return Image(systemName: "photo") // fallback
        }
        
        return Image(uiImage: uiImage)
    }

    // MARK: - Load Video URL from CommonComponents/Videos/ (optional)

    func videoURL(named name: String) -> URL? {
        let videoPath = "CommonComponents/Videos/\(name)"
        return bundle.url(forResource: videoPath, withExtension: nil)
    }
}