//
//  GlassCard.swift
//  MySampleTEsts
//
//  Created by Vic on 11/02/2026.
//

import SwiftUI

struct GlassCard: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
                .frame(width: 300, height: 200)

            Text("Glass Card")
                .font(.title)
                .foregroundColor(.black.opacity(0.5))
        }
    }
}

#Preview {
    GlassCard()
}
