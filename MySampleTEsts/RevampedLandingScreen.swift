//
//  RevampedLandingScreen.swift
//  MySampleTEsts
//
//  Created by Vic on 19/03/2026.
//
//  Stack-reveal effect:
//  Cards below the fold compress into a deck. Scrolling peels each card
//  out of the stack and settles it into its natural position.
//

import SwiftUI
import CoreLocation
import PhotosUI

// MARK: - Preference key: tracks each card's live global screen Y
private struct CardYKey: PreferenceKey {
    static var defaultValue: [Int: CGFloat] = [:]
    static func reduce(value: inout [Int: CGFloat], nextValue: () -> [Int: CGFloat]) {
        value.merge(nextValue()) { $1 }
    }
}

// MARK: - Main View
struct RevampedLandingScreen: View {

    // ── Navigation state (unchanged) ─────────────────────────────────────────
    @State var isNavigateToUsernamePassword: Bool = false
    @State var isNavigateToMpin: Bool = false
    @State var biometricAuthType = ""
    @State var isShowAlertDialog = false
    @State var themeState: Int = 1
    @State var confirmButtonText = ""
    @State var dismissButtonText = "Okay"
    let contentType = "revamped_landing"
    let screen = "RevampedLandingScreen"
    @State var isShowPermissionAlert = false
    @State var permissionAlertMessage = ""
    @State var isLocationAuthorized = false
    @State var isSaveDeviceDetails = false
    @State var isCameraAuthorized = false
    @State var isShowEnablePermissionsAlert = false
    @State var isNavigateToIdentityDetailsView = false
    @State var isNavigateToForex: Bool = false
    @State var isNavigateToChatbot: Bool = false
    @State var isNavigateToSelfService: Bool = false
    @State var isNavigateKingdomScreen = false
    @State var isNavigateBancassuranceScreen = false
    @State var isNavigateAssetScreen = false
    @State var isNavigateCooploanScreen = false
    @State var isNavigatemsmeScreen = false
    @State var isNavigatediasporaScreen = false
    @State var isShowDiscoverCards = false
    @State var isNavigateCoopCards = false
    @State var isNavigateToOpenAccountView = false
    @State var isNavigateToNewOpenAccountWebView = false
    @State var isNavigateToCustomerDetailsView = false
    @State var isOpenAccountClicked = false
    @State var isOpenWalletClicked = false
    @State var isRegisterClicked = false
    @State var isNavigateToAccountTypesView = false
    @State var isNavigateToSetAllSecurityQuestionsView = false
    @State var idNumber = ""
    @State var isPublicKeyFetched = false
    @State var holiday: Holiday? = nil
    @State private var scrollHintOffset: CGFloat = 0
    @Environment(\.scenePhase) private var scenePhase

    // ── Stack-reveal state ────────────────────────────────────────────────────
    /// Live global-Y of each card group top edge, populated via PreferenceKey.
    @State private var cardY: [Int: CGFloat] = [:]

    // ── Tuning ────────────────────────────────────────────────────────────────
    /// Cards begin stacking when their top edge crosses below this screen Y.
    private var foldLine: CGFloat { UIScreen.main.bounds.height - 380 }
    /// Distance over which a card transitions fully from stacked → revealed.
    private let revealRange: CGFloat = 220
    /// Max upward nudge (pt) for a fully stacked card.
    private let maxLift: CGFloat = 52
    private let totalCards: Int  = 7

    // MARK: Stack math

    /// 0 = fully revealed, 1 = fully stacked below fold.
    private func p(_ i: Int) -> CGFloat {
        let y = cardY[i] ?? (foldLine + revealRange)
        guard y > foldLine else { return 0 }
        return min(1, (y - foldLine) / revealRange)
    }

    /// Cards compress upward while below the fold.
    /// Peer influence lets cards above pull later ones slightly closer,
    /// creating the natural fanning-deck look.
    private func liftOffset(_ i: Int) -> CGFloat {
        let ownLift  = p(i) * maxLift
        let peerPull = (0..<i).reduce(0) { acc, j in acc + p(j) * 6 }
        return -(ownLift + peerPull)
    }

    private func zIdx(_ i: Int) -> Double { Double(totalCards - i) }

    // MARK: Card wrapper

    @ViewBuilder
    private func card<C: View>(index i: Int, @ViewBuilder _ content: () -> C) -> some View {
        let prog = p(i)
        content()
            .background(
                GeometryReader { g in
                    Color.clear.preference(
                        key: CardYKey.self,
                        value: [i: g.frame(in: .global).minY]
                    )
                }
            )
            .offset(y: liftOffset(i))
            .scaleEffect(1 - prog * 0.025, anchor: .bottom)
            .opacity(Double(1 - prog * 0.10))
            .shadow(color: .black.opacity(0.05 + 0.18 * Double(prog)), radius: 10, x: 0, y: 5)
            .zIndex(zIdx(i))
    }

    // MARK: Body

    var body: some View {
        NavigationView {
            ZStack {
                GeometryReader { geo in
                    Image("lionrvbg")
                        .resizable()
                        .frame(width: geo.size.width, height: geo.size.height)
                        .clipped()
                        .brightness(-0.05)
                }
                .ignoresSafeArea()

                ScrollViewReader { proxy in
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 0) {

                            // Logo area
                            VStack {
                                Spacer().frame(height: 120)
                                Image("layer")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 55)
                                Spacer().frame(height: 40)
                            }

                            Spacer().frame(height: 50)

                            fixedHeaderSection
                                .id("topAnchor")

                            // Card deck — spacing: 0, each group owns its bottom padding
                            VStack(spacing: 0) {

                                // 0 – Open Account
                                card(index: 0) {
                                    OpenAccountCard(onClickRegister: {})
                                        .padding(.bottom, 14)
                                }

                                // 1 – Self Service | Co-op Loans
                                card(index: 1) {
                                    HStack(spacing: 12) {
                                        SelfServiceCard(onClick: { isNavigateToSelfService = true })
                                        CoopLoansCard(onClick: { isNavigateCooploanScreen = true })
                                    }
                                    .padding(.bottom, 14)
                                }

                                // 2 – FX Rates | Chat with Us
                                card(index: 2) {
                                    HStack(spacing: 12) {
                                        FXRatesCard(onClick: { isNavigateToForex = true })
                                        ChatWithUsCard(onClick: { isNavigateToChatbot = true })
                                    }
                                    .padding(.bottom, 14)
                                }

                                // 3 – Asset Finance | Kingdom Securities
                                card(index: 3) {
                                    HStack(spacing: 12) {
                                        AssetFinanceCard(onClick: { isNavigateAssetScreen = true })
                                        KingdomSecuritiesCard(onClick: { isNavigateKingdomScreen = true })
                                    }
                                    .padding(.bottom, 14)
                                }

                                // 4 – Co-op Cards
                                card(index: 4) {
                                    CoopCardsCard(onClick: { isNavigateCoopCards = true })
                                        .padding(.bottom, 14)
                                }

                                // 5 – Diaspora Banking | MSME
                                card(index: 5) {
                                    HStack(spacing: 12) {
                                        DiasporaBankingCard(onClick: { isNavigatediasporaScreen = true })
                                        MSMECard(onClick: { isNavigatemsmeScreen = true })
                                    }
                                    .padding(.bottom, 14)
                                }

                                // 6 – Bancassurance | Listed Homes
                                card(index: 6) {
                                    HStack(spacing: 12) {
                                        BancassuranceCard(onClick: { isNavigateBancassuranceScreen = true })
                                        ListedHomesCard(onClick: { isShowDiscoverCards = true })
                                    }
                                    .padding(.bottom, 14)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 16)

                            Spacer().frame(height: 150)
                        }
                    }
                    .onPreferenceChange(CardYKey.self) { cardY = $0 }
                    .onAppear {
                        withAnimation { proxy.scrollTo("topAnchor", anchor: .top) }
                    }
                }

                VStack {
                    Spacer()
                    HStack { LoginButtonsSection }
                }
            }
            .onChange(of: scenePhase) { _ in }
            .sheet(isPresented: $isShowDiscoverCards)           { SafariView(url: URL(string: "https://goodhome.co.ke/")!) }
            .sheet(isPresented: $isNavigateKingdomScreen)       { SafariView(url: URL(string: "https://kingdomsecurities.co.ke/")!) }
            .sheet(isPresented: $isNavigateBancassuranceScreen) { SafariView(url: URL(string: "https://insurance.co-opbank.co.ke/#cta-banc")!) }
            .sheet(isPresented: $isNavigateAssetScreen)         { SafariView(url: URL(string: "https://assetfinance.co-opbank.co.ke/")!) }
            .sheet(isPresented: $isNavigateCooploanScreen)      { SafariView(url: URL(string: "https://www.co-opbank.co.ke/personal-banking/borrow/")!) }
            .sheet(isPresented: $isNavigatemsmeScreen)          { SafariView(url: URL(string: "https://msme.co-opbank.co.ke/")!) }
            .sheet(isPresented: $isNavigatediasporaScreen)      { SafariView(url: URL(string: "https://diaspora.co-opbank.co.ke/")!) }
            .sheet(isPresented: $isNavigateCoopCards)           { SafariView(url: URL(string: "https://www.co-opbank.co.ke/personal-banking/cards/")!) }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .ignoresSafeArea(edges: .bottom)
        .alert("Permission Required", isPresented: $isShowPermissionAlert) {
            Button("Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) { UIApplication.shared.open(url) }
            }
            Button("Cancel", role: .cancel) {}
        } message: { Text(permissionAlertMessage) }
    }

    // MARK: - Sub-views

    var fixedHeaderSection: some View {
        VStack(spacing: 0) {
            Capsule()
                .fill(Color.gray)
                .frame(width: 46, height: 5)
                .padding(.top, 18)
            HeaderSection()
        }
    }

    var appName: String    { Bundle.main.infoDictionary?["CFBundleName"]               as? String ?? "Unknown" }
    var appVersion: String { Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown" }

    private func requestPhotoLibraryAccess() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { newStatus in
                print(newStatus == .authorized ? "DEBUG: Access granted." : "DEBUG: Access denied.")
            }
        case .restricted, .denied: print("DEBUG: Access denied or restricted.")
        case .authorized:          print("DEBUG: Access already granted.")
        case .limited:             print("DEBUG: Access limited.")
        @unknown default:          print("DEBUG: Unknown authorization status.")
        }
    }

    var LoginButtonsSection: some View {
        VStack(spacing: 12) {
            Button(action: { isNavigateToUsernamePassword = true }) {
                Text("Login")
                    .font(.custom("ProductSans-Medium", size: 18))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.gray)
                    .cornerRadius(12)
            }
        }
        .padding(.horizontal, 40)
        .padding(.top, 20)
        .padding(.bottom, 40)
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Preview
#Preview { RevampedLandingScreen() }

// MARK: - Supporting types (all unchanged from original)

struct AppIcon: View {
    let imageName: String
    let fallbackSystemName: String
    let size: CGFloat
    let color: Color

    init(_ imageName: String, fallback: String, size: CGFloat = 55, color: Color = Color(hex: "7CB342")) {
        self.imageName = imageName; self.fallbackSystemName = fallback
        self.size = size; self.color = color
    }

    var body: some View {
        Group {
            if UIImage(named: imageName) != nil {
                Image(imageName).resizable().aspectRatio(contentMode: .fit)
            } else {
                ZStack {
                    Circle().fill(color.opacity(0.15)).frame(width: size, height: size)
                    Image(systemName: fallbackSystemName)
                        .font(.system(size: size * 0.45, weight: .medium))
                        .foregroundColor(color)
                }
            }
        }
        .frame(width: size, height: size)
    }
}

extension Color {
    static let cardBackground      = Color.black.opacity(0.55)
    static let cardBackgroundSolid = Color(hex: "262626").opacity(0.85)
}

struct HeaderSection: View {
    var body: some View {
        ZStack {
            VStack(spacing: 6) {
                Text("Welcome back")
                    .font(.custom("ProductSans-Medium", size: 26))
                    .foregroundColor(Color.green)
            }
            .padding(.vertical, 16)
        }
    }
}

struct ScaleButtonStyleTwo: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

struct ScaleButtonStyleForLogin: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 6).padding(.vertical, 6)
            .background(ZStack {
                RoundedRectangle(cornerRadius: 16).fill(.ultraThinMaterial).opacity(0.1)
                RoundedRectangle(cornerRadius: 16).fill(
                    LinearGradient(colors: [Color.gray.opacity(0.05), .clear],
                                   startPoint: .topLeading, endPoint: .bottomTrailing))
                RoundedRectangle(cornerRadius: 16).strokeBorder(
                    LinearGradient(colors: [Color.white.opacity(0.3), Color.white.opacity(0.1)],
                                   startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
            })
            .shadow(color: Color.gray.opacity(0.03), radius: 10, x: 0, y: 4)
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

struct OpenAccountCard: View {
    var onClickRegister: () -> Void
    var body: some View {
        Button(action: onClickRegister) {
            HStack(alignment: .center, spacing: 3) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Open an account")
                        .font(.custom("ProductSans-Medium", size: 18)).foregroundColor(.black)
                    Text("Start banking in minutes! Open your account online instantly, anytime.")
                        .font(.custom("ProductSans-Light", size: 13)).foregroundColor(.black)
                        .lineLimit(2).multilineTextAlignment(.leading)
                }
                Spacer()
                AppIcon("hdthree", fallback: "lock.shield.fill", size: 98)
            }
            .padding(.horizontal, 18).padding(.vertical, 16)
            .background(RoundedRectangle(cornerRadius: 12)
                .fill(LinearGradient(gradient: Gradient(colors: [
                    Color.black.opacity(0), Color.black.opacity(0), Color.black.opacity(0.1),
                    Color.black.opacity(0.2), Color.black.opacity(0.3), Color.black.opacity(0.35)]),
                    startPoint: .top, endPoint: .bottom)))
            .foregroundColor(.white).background(Color.gray).cornerRadius(12)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.blue, lineWidth: 1))
        }
        .buttonStyle(ScaleButtonStyleTwo())
    }
}

struct FXRatesCard: View {
    var onClick: () -> Void
    var body: some View {
        Button(action: onClick) {
            ZStack(alignment: .bottomTrailing) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("FX Rates").font(.custom("ProductSans-Medium", size: 16)).foregroundColor(.green)
                    Text("Make informed decisions with our real-time FX rates")
                        .font(.custom("ProductSans-Regular", size: 12)).foregroundColor(Color.green.opacity(0.55)).lineLimit(3)
                    Spacer()
                }.frame(maxWidth: .infinity, alignment: .leading)
                Image("hdone").resizable().aspectRatio(contentMode: .fit).frame(width: 85, height: 85).offset(x: 5, y: 10)
            }
            .padding(14).frame(maxWidth: .infinity).frame(height: 150)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.55)))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3), lineWidth: 1))
        }.buttonStyle(ScaleButtonStyleTwo())
    }
}

struct ChatWithUsCard: View {
    var onClick: () -> Void
    var body: some View {
        Button(action: onClick) {
            ZStack(alignment: .bottomTrailing) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Chat with us").font(.custom("ProductSans-Medium", size: 16)).foregroundColor(.green)
                    Text("Learn about features and products by engaging our Chatbot")
                        .font(.custom("ProductSans-Regular", size: 12)).foregroundColor(Color.green.opacity(0.55)).lineLimit(3)
                    Spacer()
                }.frame(maxWidth: .infinity, alignment: .leading)
                Image("hdtwo").resizable().aspectRatio(contentMode: .fit).frame(width: 85, height: 85).offset(x: 5, y: 10)
            }
            .padding(14).frame(maxWidth: .infinity).frame(height: 150)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.55)))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3), lineWidth: 1))
        }.buttonStyle(ScaleButtonStyleTwo())
    }
}

struct SelfServiceCard: View {
    var onClick: () -> Void
    var body: some View {
        Button(action: onClick) {
            ZStack(alignment: .bottomTrailing) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Self Service").font(.custom("ProductSans-Medium", size: 16)).foregroundColor(.green)
                    Text("We've got your back — safe, secure, and always here to help.")
                        .font(.custom("ProductSans-Regular", size: 12)).foregroundColor(Color.green.opacity(0.55)).lineLimit(3)
                    Spacer()
                }.frame(maxWidth: .infinity, alignment: .leading)
                Image("hdfour").resizable().aspectRatio(contentMode: .fit).frame(width: 65, height: 65).offset(x: 5, y: 10)
            }
            .padding(14).frame(maxWidth: .infinity).frame(height: 150)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.55)))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3), lineWidth: 1))
        }.buttonStyle(ScaleButtonStyleTwo())
    }
}

struct CoopLoansCard: View {
    var onClick: () -> Void
    var body: some View {
        Button(action: onClick) {
            ZStack(alignment: .bottomTrailing) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Co-op loans").font(.custom("ProductSans-Medium", size: 16)).foregroundColor(.green)
                    Text("Access our different loans to unlock your dream")
                        .font(.custom("ProductSans-Regular", size: 12)).foregroundColor(Color.green.opacity(0.55)).lineLimit(3)
                    Spacer()
                }.frame(maxWidth: .infinity, alignment: .leading)
                Image("loginhd").resizable().aspectRatio(contentMode: .fit).frame(width: 85, height: 85).offset(x: 5, y: 10)
            }
            .padding(14).frame(maxWidth: .infinity).frame(height: 150)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.55)))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3), lineWidth: 1))
        }.buttonStyle(ScaleButtonStyleTwo())
    }
}

struct AssetFinanceCard: View {
    var onClick: () -> Void
    var body: some View {
        Button(action: onClick) {
            ZStack(alignment: .bottomTrailing) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Asset Finance").font(.custom("ProductSans-Medium", size: 16)).foregroundColor(.green)
                    Text("Get flexible Asset Financing as you acquire assets")
                        .font(.custom("ProductSans-Regular", size: 12)).foregroundColor(Color.green.opacity(0.55)).lineLimit(3)
                    Spacer()
                }.frame(maxWidth: .infinity, alignment: .leading)
                Image("Assetfinance").resizable().aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80).scaledToFit().offset(x: 5, y: 10)
            }
            .padding(14).frame(maxWidth: .infinity).frame(height: 150)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.55)))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3), lineWidth: 1))
        }.buttonStyle(ScaleButtonStyleTwo())
    }
}

struct SocialMediaCard: View {
    var body: some View {
        Button(action: {}) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Social Media").font(.custom("ProductSans-Medium", size: 16)).foregroundColor(.white)
                Text("Contact us via our social media platforms")
                    .font(.custom("ProductSans-Regular", size: 12)).foregroundColor(Color.white.opacity(0.55)).lineLimit(2)
                Spacer()
                HStack(spacing: 8) {
                    SocialIconButton(imageName: "x_icon",        systemFallback: "xmark",        backgroundColor: .black)
                    SocialIconButton(imageName: "facebook_icon", systemFallback: "f.square.fill", backgroundColor: Color(hex: "1877F2"))
                    SocialIconButton(imageName: "whatsapp_icon", systemFallback: "phone.fill",    backgroundColor: Color(hex: "25D366"))
                }
            }
            .padding(14).frame(maxWidth: .infinity, alignment: .leading).frame(height: 150)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.black.opacity(0.6)))
        }.buttonStyle(ScaleButtonStyleTwo())
    }
}

struct SocialIconButton: View {
    let imageName: String; let systemFallback: String; let backgroundColor: Color
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8).fill(backgroundColor).frame(width: 38, height: 38)
            if UIImage(named: imageName) != nil {
                Image(imageName).resizable().aspectRatio(contentMode: .fit).frame(width: 20, height: 20)
            } else {
                Image(systemName: systemFallback).font(.system(size: 16, weight: .bold)).foregroundColor(.white)
            }
        }
    }
}

struct CoopCardsCard: View {
    var onClick: () -> Void
    var body: some View {
        Button(action: onClick) {
            HStack(alignment: .center, spacing: 12) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Co-op Cards").font(.custom("ProductSans-Medium", size: 18)).foregroundColor(.green)
                    Text("Your gateway to smarter and safer card transactions.")
                        .font(.custom("ProductSans-Regular", size: 13)).foregroundColor(Color.green.opacity(0.55))
                        .lineLimit(2).multilineTextAlignment(.leading)
                }
                Spacer()
                AppIcon("hdseven", fallback: "lock.shield.fill", size: 95)
            }
            .padding(.horizontal, 18).padding(.vertical, 16)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.55)))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3), lineWidth: 1))
        }.buttonStyle(ScaleButtonStyleTwo())
    }
}

struct KingdomSecuritiesCard: View {
    var onClick: () -> Void
    var body: some View {
        Button(action: onClick) {
            ZStack(alignment: .bottomTrailing) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Kingdom Securities").font(.custom("ProductSans-Medium", size: 16)).foregroundColor(.green)
                    Text("Trade shares via our Online Share Trading platform or the KSL Trading app.")
                        .font(.custom("ProductSans-Regular", size: 12)).foregroundColor(Color.green.opacity(0.55)).lineLimit(3)
                    Spacer()
                }.frame(maxWidth: .infinity, alignment: .leading)
                Image("hdfive").resizable().aspectRatio(contentMode: .fit).frame(width: 85, height: 85).offset(x: 5, y: 10)
            }
            .padding(14).frame(maxWidth: .infinity).frame(height: 150)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.55)))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3), lineWidth: 1))
        }.buttonStyle(ScaleButtonStyleTwo())
    }
}

struct DiasporaBankingCard: View {
    var onClick: () -> Void
    var body: some View {
        Button(action: onClick) {
            ZStack(alignment: .bottomTrailing) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Diaspora Banking").font(.custom("ProductSans-Medium", size: 16)).foregroundColor(.green)
                    Text("Safe, flexible and convenient banking back home in Kenya")
                        .font(.custom("ProductSans-Regular", size: 12)).foregroundColor(Color.green.opacity(0.55)).lineLimit(3)
                    Spacer()
                }.frame(maxWidth: .infinity, alignment: .leading)
                Image("hdeight").resizable().aspectRatio(contentMode: .fit).frame(width: 85, height: 85).offset(x: 5, y: 10)
            }
            .padding(14).frame(maxWidth: .infinity).frame(height: 150)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.55)))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3), lineWidth: 1))
        }.buttonStyle(ScaleButtonStyleTwo())
    }
}

struct MSMECard: View {
    var onClick: () -> Void
    var body: some View {
        Button(action: onClick) {
            ZStack(alignment: .bottomTrailing) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("MSME").font(.custom("ProductSans-Medium", size: 16)).foregroundColor(.green)
                    Text("Access our tailor-made solutions to help you grow your business.")
                        .font(.custom("ProductSans-Regular", size: 12)).foregroundColor(Color.green.opacity(0.55)).lineLimit(3)
                    Spacer()
                }.frame(maxWidth: .infinity, alignment: .leading)
                Image("hdnine").resizable().aspectRatio(contentMode: .fit).frame(width: 85, height: 85).offset(x: 5, y: 10)
            }
            .padding(14).frame(maxWidth: .infinity).frame(height: 150)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.55)))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3), lineWidth: 1))
        }.buttonStyle(ScaleButtonStyleTwo())
    }
}

struct BancassuranceCard: View {
    var onClick: () -> Void
    var body: some View {
        Button(action: onClick) {
            ZStack(alignment: .bottomTrailing) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Bancassurance").font(.custom("ProductSans-Medium", size: 16)).foregroundColor(.green)
                    Text("Get your insurance within minutes")
                        .font(.custom("ProductSans-Regular", size: 12)).foregroundColor(Color.green.opacity(0.55)).lineLimit(2)
                    Spacer()
                }.frame(maxWidth: .infinity, alignment: .leading)
                Image("hdten").resizable().aspectRatio(contentMode: .fit).frame(width: 85, height: 85).offset(x: 5, y: 10)
            }
            .padding(14).frame(maxWidth: .infinity).frame(height: 150)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.55)))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3), lineWidth: 1))
        }.buttonStyle(ScaleButtonStyleTwo())
    }
}

struct ListedHomesCard: View {
    var onClick: () -> Void
    var body: some View {
        Button(action: onClick) {
            ZStack(alignment: .bottomTrailing) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Listed Homes").font(.custom("ProductSans-Medium", size: 16)).foregroundColor(.green)
                    Text("Actualise your dream of owning property")
                        .font(.custom("ProductSans-Regular", size: 12)).foregroundColor(Color.green.opacity(0.55)).lineLimit(2)
                    Spacer()
                }.frame(maxWidth: .infinity, alignment: .leading)
                Image("hdeleven").resizable().aspectRatio(contentMode: .fit).frame(width: 85, height: 85).offset(x: 5, y: 10)
            }
            .padding(14).frame(maxWidth: .infinity).frame(height: 150)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.55)))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3), lineWidth: 1))
        }.buttonStyle(ScaleButtonStyleTwo())
    }
}

// MARK: - Utilities (unchanged from original)

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a,r,g,b) = (255,(int>>8)*17,(int>>4 & 0xF)*17,(int & 0xF)*17)
        case 6: (a,r,g,b) = (255,int>>16,int>>8 & 0xFF,int & 0xFF)
        case 8: (a,r,g,b) = (int>>24,int>>16 & 0xFF,int>>8 & 0xFF,int & 0xFF)
        default:(a,r,g,b) = (1,1,1,0)
        }
        self.init(.sRGB, red: Double(r)/255, green: Double(g)/255, blue: Double(b)/255, opacity: Double(a)/255)
    }
}

struct FrostedInputFieldRevamp: View {
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    @FocusState private var isFocused: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.gray.opacity(0.08))
                .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(.ultraThinMaterial))
                .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(isFocused ? Color(red:0.62,green:0.83,blue:0.39).opacity(0.6) : Color.green.opacity(0.15),
                            lineWidth: isFocused ? 3 : 1))
                .shadow(color: isFocused ? Color(red:0.62,green:0.83,blue:0.39).opacity(0.2) : Color.black.opacity(0.05),
                        radius: isFocused ? 12 : 4, y: isFocused ? 4 : 2)
            HStack(spacing: 12) {
                if isSecure {
                    SecureField(placeholder, text: $text)
                        .foregroundColor(Color.green.opacity(0.85))
                        .font(.custom("ProductSans-Regular", size: 17)).focused($isFocused)
                } else {
                    TextField(placeholder, text: $text)
                        .foregroundColor(Color.green.opacity(0.85))
                        .font(.custom("ProductSans-Regular", size: 17)).focused($isFocused)
                }
            }.padding(.horizontal, 20).padding(.vertical, 18)
        }
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isFocused)
        .padding(.vertical, 5).frame(height: 47)
        .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
}

extension View {
    func placeholder<C: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> C
    ) -> some View {
        ZStack(alignment: alignment) { if shouldShow { placeholder() }; self }
    }
}

struct Blur: UIViewRepresentable {
    var style: UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView { UIVisualEffectView(effect: UIBlurEffect(style: style)) }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}
