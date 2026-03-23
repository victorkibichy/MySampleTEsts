//
//  MoneyMovesCard.swift
//  MySampleTEsts
//
//  Created by Vic on 17/03/2026.
//

import SwiftUI


struct MoneyMovesCard: View {
    var data: MoneyMovesData  = MoneyMovesData()
    var onTap: () -> Void     = {}
    var onDismiss: () -> Void = {}

    @State private var visible   = false
    @State private var shimmerX: CGFloat = -220

    var body: some View {
        Button(action: onTap) {
            ZStack {
                // Background image asset fills the card
                Image("Group 179087")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .mask(RoundedRectangle(cornerRadius: 16))

                // Shimmer overlay
                Color.white.opacity(0.08)
                    .frame(width: 80)
                    .offset(x: shimmerX)
                    .clipped()
                    .mask(RoundedRectangle(cornerRadius: 16))
                    .blendMode(.overlay)

                HStack(spacing: 14) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Your money had a whole year")
                            .font(.custom("ProductSans-Bold", size: 16)).foregroundColor(.white)
                        Text("This is how your money moved in \(data.year). Tap to watch.")
                            .font(.custom("ProductSans-Regular", size: 12)).foregroundColor(.white)
                    }
                    Spacer()
                }
                .padding(.horizontal, 18).padding(.vertical, 16)
            }
            .frame(height: 50)
            .overlay(alignment: .topTrailing) {
                Button(action: onDismiss) {
                    Image(systemName: "xmark")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.white.opacity(0.9))
                        .padding(8)
                        .background(Color.white.opacity(0.18))
                        .clipShape(Circle())
                }
                .padding(.bottom, 10)
                .padding(.trailing, 12)
                .offset(x: 7, y: -20)
            }
            
        }
        .buttonStyle(.plain)
        .scaleEffect(visible ? 1 : 0.92).opacity(visible ? 1 : 0)
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.68)) { visible = true }
            withAnimation(.linear(duration: 1.6).delay(0.7)) { shimmerX = 400 }
        }
    }
}
#Preview {
  MoneyMovesCard()
}

class MoneyMovesData{
    
    public var year: String = "Money Moves"
}
