//
//  OverlappingFeedView.swift
//  MySampleTEsts
//
//  Created by Vic on 19/03/2026.
//


import SwiftUI

struct OverlappingFeedView: View {
    @EnvironmentObject var model: AppModel

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            ScrollView(.vertical, showsIndicators: false) {
                // The negative spacing is the secret sauce for the overlap effect
                LazyVStack(spacing: -160) { 
                    
                    // 1. Top Header Area
                    headerSection
                    
                    // 2. Verse of the Day Card
                    verseOfTheDayCard
                        .padding(.horizontal, 16)
                    
                    // 3. "Make Him Known" Card (Overlaps the Verse card)
                    mediaCard(title: "Make Him Known", subtitle: "Guided Scripture", hasImage: true)
                        .padding(.horizontal, 16)
                    
                    // 4. Guided Prayer Card (Overlaps the Media card)
                    prayerCard
                        .padding(.horizontal, 16)
                    
                    // 5. Reading Plan Card (Overlaps the Prayer card)
                    readingPlanCard
                        .padding(.horizontal, 16)
                    
                    Spacer().frame(height: 100)
                }
                .padding(.top, 20)
            }
        }
        .foregroundColor(.white)
    }
    
    // MARK: - Header
    var headerSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Today")
                    .font(.system(size: 28, weight: .bold))
                Text("Community")
                    .font(.system(size: 28, weight: .medium))
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding(.horizontal, 16)
            
            Text("Good afternoon, Victor")
                .font(.system(size: 24, weight: .semibold))
                .padding(.horizontal, 16)
            
            // Easter Promo Banner
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("You can change lives this Easter.")
                        .font(.system(size: 16, weight: .bold))
                    Text("Discover what it means to sow God's Word and bring life-changing hope to others this Easter.")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                        .lineLimit(3)
                    HStack(spacing: 15) {
                        Text("Watch Now").foregroundColor(.white)
                        Text("Dismiss").foregroundColor(.gray)
                    }
                    .font(.system(size: 14, weight: .medium))
                }
                Spacer()
                Image(systemName: "leaf.circle.fill") // Placeholder for the woman image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .cornerRadius(12)
            }
            .padding(16)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            .padding(.horizontal, 16)
        }
    }
    
    // MARK: - Verse Card
    var verseOfTheDayCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Verse of the day")
                .font(.system(size: 12))
                .foregroundColor(.gray)
            Text("Psalms 105:1")
                .font(.system(size: 20, weight: .bold))
            
            Text("Hallelujah! Thank God! Pray to him by name! Tell everyone you meet what he has done! Sing him songs, belt out hymns, translate his wonders into music! Honor his holy name with Hallelujahs, you who seek God. Live a happy life! Keep your eyes open for God,...")
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.9))
                .lineLimit(6)
            
            HStack(spacing: 20) {
                VStack(spacing: 4) {
                    Image(systemName: "heart")
                    Text("546.9K").font(.system(size: 10))
                }
                VStack(spacing: 4) {
                    Image(systemName: "message")
                    Text("9,824").font(.system(size: 10))
                }
                VStack(spacing: 4) {
                    Image(systemName: "square.and.arrow.up")
                    Text("166.9K").font(.system(size: 10))
                }
                Spacer()
                Image(systemName: "ellipsis")
            }
            .foregroundColor(.white.opacity(0.7))
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color(bex: "D4C5A3"), Color(bex: "8B7355")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
    }
    
    // MARK: - Generic Media Card (Make Him Known)
    func mediaCard(title: String, subtitle: String, hasImage: Bool) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            // The noisy grey area
            ZStack(alignment: .bottomLeading) {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        // Simulating noise texture with a simple pattern or color
                        Color.black.opacity(0.1)
                    )
                    .frame(height: 250)
                
                if hasImage {
                    Image(systemName: "person.circle.fill") // Placeholder for the man's face
                        .resizable()
                        .frame(width: 60, height: 60)
                        .cornerRadius(10)
                        .padding(16)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 18, weight: .bold))
                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.gray.opacity(0.2))
        }
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
    }
    
    // MARK: - Prayer Card
    var prayerCard: some View {
        HStack(alignment: .bottom, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Guided prayer")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                Text("What's on your mind? God wants to hear from you.")
                    .font(.system(size: 18, weight: .bold))
                    .lineLimit(2)
                HStack {
                    Image(systemName: "play.fill")
                        .font(.system(size: 10))
                    Text("4-6 min")
                        .font(.system(size: 12))
                }
                .foregroundColor(.gray)
            }
            Spacer()
            Image(systemName: "hand.raised.circle.fill")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(.purple.opacity(0.5))
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.15))
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
    }

    // MARK: - Reading Plan Card
    var readingPlanCard: some View {
        HStack(alignment: .bottom, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "checkmark.circle")
                    Text("Day 1")
                }
                .font(.system(size: 12))
                .foregroundColor(.gray)
                
                Text("Faith That Endures")
                    .font(.system(size: 18, weight: .bold))
            }
            Spacer()
            Image(systemName: "cross.case.fill") // Placeholder for book cover
                .resizable()
                .frame(width: 50, height: 70)
                .foregroundColor(.orange)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.15))
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
    }
}

// Helper for Hex Colors
extension Color {
    init(tex: String) {
        let hex = tex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct OverlappingFeedView_Previews: PreviewProvider {
    static var previews: some View {
        OverlappingFeedView()
    }
}
