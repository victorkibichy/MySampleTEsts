//
//  MyReusableView.swift
//  MySampleTests
//
//  Created by Vic on 13/10/2025.
//

import SwiftUI
import AVKit
import AVFoundation
import UIKit
internal import Combine

// MARK: - Reusable View

struct MyReusableView: View {
    var body: some View {
//        HStack {
//            Image(systemName: "house.fill")
//                .resizable()
//                .scaledToFit()
//                .frame(width: 40, height: 40)
//                .foregroundColor(.blue)
//        }
        ZStack {
            LoopingVideoView(videoName: "newvideo")
        }
    }
}

#Preview {
    MyReusableView()
//        .?(ThemesViewModel())
        .environmentObject(HolidayViewModel())
}

// MARK: - Holiday Enum

enum Holiday: Codable {
    case publicHoliday
    case christmas
    case birthday
    case newYear
    case valentine
    case none
}

// MARK: - ViewModels

struct ThemesViewModel {
//    var objectWillChange: ObservableObjectPublisher
    
     var isDarkModeOn: Bool = false
     var savedResource: String?
}

final class HolidayViewModel: ObservableObject {
    @Published var holiday: Holiday = .christmas
}

struct UserProfileViewmodel {}

// MARK: - Holiday Logic

func getHolidayInfo() -> Holiday {
    let calendar = Calendar.current
    let today = Date()
    let day = calendar.component(.day, from: today)
    let month = calendar.component(.month, from: today)
    let year = calendar.component(.year, from: today)

    let publicHolidays = [
        calendar.date(from: .init(year: year, month: 5, day: 1)),
        calendar.date(from: .init(year: year, month: 6, day: 1)),
        calendar.date(from: .init(year: year, month: 10, day: 20)),
        calendar.date(from: .init(year: year, month: 12, day: 12))
    ].compactMap { $0 }

    if let dobString = UserDefaults.standard.string(forKey: "user_date_of_birth"),
       let birthday = parseDOBString(dobString) {

        if calendar.component(.day, from: birthday) == day &&
            calendar.component(.month, from: birthday) == month {
            return .birthday
        }
    }

    if month == 12 && (15...31).contains(day) {
        return .christmas
    }

    if publicHolidays.contains(where: { calendar.isDate(today, inSameDayAs: $0) }) {
        return .publicHoliday
    }

    if month == 1 && day == 1 {
        return .newYear
    }

    if month == 2 && (10...16).contains(day) {
        return .valentine
    }

    return .none
}

// MARK: - DOB Parsing

func parseDOBString(_ dob: String) -> Date? {
    if dob.contains("/") { return parseSlash(dob) }
    if dob.contains("-") { return parseDash(dob) }
    return nil
}

private func parseSlash(_ dob: String) -> Date? {
    let parts = dob.split(separator: "/")
    guard parts.count == 3,
          let a = Int(parts[0]),
          let b = Int(parts[1]),
          let y = Int(parts[2]) else { return nil }

    let (m, d) = a > 12 ? (b, a) : (a, b)
    return Calendar.current.date(from: .init(year: y, month: m, day: d))
}

private func parseDash(_ dob: String) -> Date? {
    let parts = dob.split(separator: "-")
    guard parts.count == 3,
          let day = Int(parts[0]),
          let yearShort = Int(parts[2]) else { return nil }

    let months: [String: Int] = [
        "JAN":1,"FEB":2,"MAR":3,"APR":4,"MAY":5,"JUN":6,
        "JUL":7,"AUG":8,"SEP":9,"OCT":10,"NOV":11,"DEC":12
    ]

    guard let month = months[String(parts[1]).uppercased()] else { return nil }
    let year = yearShort <= 30 ? 2000 + yearShort : 1900 + yearShort

    return Calendar.current.date(from: .init(year: year, month: month, day: day))
}

// MARK: - Theme Helpers

func isSystemThemeDark() -> Bool {
    UITraitCollection.current.userInterfaceStyle == .dark
}

func getBackgroundResource(
    holiday: Holiday,
    darkTheme: Int,
    systemTheme: Bool
) -> String {

    let isDark = darkTheme == 2 || (darkTheme != 1 && systemTheme)

    switch holiday {
    case .christmas:
        return "newchristmas"
    case .birthday:
        return "birthdaybg_dark"
    case .newYear:
        return isDark ? "blacknewyear" : "whitenewyear"
    case .valentine:
        return "valentine"
    case .publicHoliday:
        return "public_holiday_bg"
    case .none:
        return isDark ? "login_bg_dark" : "lightimage"
    }
}

// MARK: - Background View

struct GSBackground: View {
    @Binding var darkTheme: Int
    let systemTheme: Bool
    let holiday: Holiday

    @State private var background: String?
     var themesVM: ThemesViewModel

    var body: some View {
        ZStack {
            if let bg = background {
                if holiday == .none {
                    Image(bg)
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                } else {
                    LoopingVideoView(videoName: bg)
                        .ignoresSafeArea()
                }
            }
        }
//        .onAppear {
//            updateBackground()
//        }
//        .onChange(of: darkTheme) { _ in
//            updateBackground()
//        }
    }

    private mutating func updateBackground() {
        let resource = getBackgroundResource(
            holiday: holiday,
            darkTheme: darkTheme,
            systemTheme: systemTheme
        )
        background = resource
        themesVM.savedResource = resource
    }
}

// MARK: - Reusable Looping Video Player

struct LoopingVideoView: View {
    let videoName: String
    @State private var player: AVPlayer?

    var body: some View {
        ZStack {
            if let url = Bundle.main.url(forResource: videoName, withExtension: "mp4") {
                VideoPlayer(player: player)
                    .onAppear {
                        if player == nil {
                            let item = AVPlayerItem(url: url)
                            player = AVPlayer(playerItem: item)

                            NotificationCenter.default.addObserver(
                                forName: .AVPlayerItemDidPlayToEndTime,
                                object: item,
                                queue: .main
                            ) { _ in
                                player?.seek(to: .zero)
                                player?.play()
                            }
                        }
                        player?.play()
                    }
                    .onDisappear {
                        player?.pause()
                        NotificationCenter.default.removeObserver(self)
                        player = nil
                    }
            } else {
                Color.black
            }
        }
    }
}
