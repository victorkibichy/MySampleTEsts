//
//  SafariTests.swift
//  MySampleTEsts
//
//  Created by Vic on 15/12/2025.
//

import Foundation
import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        
        
        
    }
    
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

}

struct SafariTests: View {
    var body: some View {
        SafariView(url : URL(string: "https://www.google.com")!  )
    }
}

#Preview {
    SafariTests()
}
