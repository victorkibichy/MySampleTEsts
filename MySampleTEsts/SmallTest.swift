//
//  SmallTest.swift
//  MySampleTEsts
//
//  Created by Vic on 11/02/2026.
//

import SwiftUI

struct SmallTest: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [.brown, .black],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .black.opacity(0.5), radius: 10, x: 5, y: 5)

            Text("Leather ")
                .foregroundColor(.white)
                .bold()
        }
        .ignoresSafeArea()
    }
}

#Preview {
    SmallTest()
}
