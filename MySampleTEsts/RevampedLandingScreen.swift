//
//  RevampedLandingScreen.swift
//  SharedFramework
//
//  Created by Gideon Rotich on 04/12/2025.
//

import SwiftUI
import CoreLocation
import PhotosUI

struct RevampedLandingScreen: View {
    @State var isNavigateToUsernamePassword: Bool = false
    @State var isNavigateToMpin: Bool = false
    @EnvironmentObject var homeviewModel: HomeviewModel
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @EnvironmentObject var loginViewmodel: LoginViewmodel
    @StateObject var registerViewModel = RegisterViewModel()
    @EnvironmentObject var themesViewModel: ThemesViewModel
    @EnvironmentObject var holidayViewModel: HolidayViewModel
    @EnvironmentObject var userProfileViewModel: UserProfileViewmodel
    @EnvironmentObject var accountTypesViewModel : AccountTypesViewModel
    @EnvironmentObject var viewModel : LoginViewmodel
    @EnvironmentObject var accountsViewModel : AccountViewModel
    @EnvironmentObject var cardsViewModel : CardsViewModel
    @State var biometricAuthType = ""
    @EnvironmentObject var dialogManager: DialogManager
    
    @State var dialogEntity = DialogEntity()
    @State var isShowAlertDialog = false
    @State var themeState: Int = 1
    @State var confirmButtonText = ""
    @State var dismissButtonText = "Okay"
    let contentType = "revamped_landing"
    let screen = "RevampedLandingScreen"
    
    @StateObject var appLocationManager = AppLocationManager()
    @State var isShowPermissionAlert = false
    @State var permissionAlertMessage = ""
    
    @State var isLocationAuthorized = false
    @State var isSaveDeviceDetails = false
    @State var isCameraAuthorized = false
    @State var isShowEnablePermissionsAlert = false
    @State var isNavigateToIdentityDetailsView = false
    @EnvironmentObject var newtworkMonitor : NetworkMonitor
    @State var toast: Toast? = nil
    @State var isNavigateToForex: Bool = false
    @EnvironmentObject var forexRatesViewModel: ForexRatesViewModel
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
    @State var onboardingJourneyType: OnboardingJourneyType = OnboardingJourneyType.normalOnboarding
    @State var isOpenAccountClicked = false
    @State var isOpenWalletClicked = false
    @State var isRegisterClicked = false
    @State var isNavigateToAccountTypesView = false
    @State var isNavigateToSetAllSecurityQuestionsView = false
    @State var idNumber = ""
    @State var isPublicKeyFetched = false
    @State var holiday: Holiday? = nil
    
    @StateObject var themeManager = ThemeManager.shared
    @State private var scrollHintOffset: CGFloat = 0
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        NavigationView {
            ZStack {
                if let holidayData = holidayViewModel.holiday,holidayData != .none  {
                    let darkTheme = themesViewModel.isDarkModeOn ?? false ? 2 : 1
                    GSBackgroundMcoop(darkTheme: darkTheme, systemTheme: isSystemThemeDark(), holiday: holidayData)
                        .ignoresSafeArea()
                } else {
                    GeometryReader { geometry in
                        Image(themeManager.selectedTheme.imageName)
                            .resizable()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .clipped()
                            .brightness(-0.05)
                    }
                    .ignoresSafeArea()
                }
                
                
                ScrollViewReader { proxy in
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack {
                            VStack {
                                Spacer().frame(height: 120)
                                
                                if let holidayData = holidayViewModel.holiday,holidayData == .none {
                                    Image("layer")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 55)
                                }
                                
                                Spacer().frame(height: 40)
                            }
                            Spacer().frame(height: 50)
                            
                            VStack(spacing: 0) {
                                
                                Capsule()
                                    .fill(Color.theme.blackAndWhite)
                                    .frame(width: 46, height: 5)
                                    .padding(.top, 18)
                                
                                HeaderSection()
                                
                                VStack(spacing: 16) {
                                    OpenAccountCard(
                                        onClickRegister: {
                                            handleOpenAccountTapped()
                                        }
                                    )
                                    
                                    HStack(spacing: 12) {
                                        SelfServiceCard(onClick: {
                                            isNavigateToSelfService = true
                                        })
                                        CoopLoansCard( onClick: {
                                            isNavigateCooploanScreen = true
                                        })
                                    }
                                    
                                    HStack(spacing: 12) {
                                        FXRatesCard(onClick: {
                                            isNavigateToForex = true
                                        })
                                        ChatWithUsCard(onClick: {
                                            isNavigateToChatbot = true
                                        })
                                    }
                                    
                                    HStack(spacing: 12) {
                                        AssetFinanceCard(onClick: {
                                            isNavigateAssetScreen = true
                                        })
                                        KingdomSecuritiesCard(onClick: {
                                            isNavigateKingdomScreen = true
                                        })
                                    }
                                    
                                    CoopCardsCard(onClick: {
                                        isNavigateCoopCards = true
                                    })
                                    
                                    HStack(spacing: 12) {
                                        DiasporaBankingCard(onClick: {
                                            isNavigatediasporaScreen = true
                                        })
                                        MSMECard(onClick: {
                                            isNavigatemsmeScreen = true
                                        })
                                    }
                                    
                                    HStack(spacing: 12) {
                                        BancassuranceCard(onClick: {
                                            isNavigateBancassuranceScreen = true
                                        })
                                        ListedHomesCard(onClick: {
                                            isShowDiscoverCards = true
                                        })
                                    }
                                    
                                    Spacer().frame(height: 150)
                                }
                                .padding(.horizontal, 16)
                                .padding(.top, 16)
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(themesViewModel.isDarkModeOn ?? false ? Color.black.opacity(0.7) : Color.theme.whiteAndBlack.opacity(0.9))
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 24))
                        }
                        .offset(y: scrollHintOffset)
                    }
                    .onAppear {
                        print("DEBUG: on Appear Revamp Landing screen ")
                        
                        //enhanceApp for session manager
                        // homeviewModel.resetNavigateViews() // !For smooth app navigation
                        // SessionViewModel.shared.logoutSession() //close any runing session
                        // dialogManager.dismissDialog() //dismiss session dialog
                        // Scroll to top when the view appears
                        withAnimation {
                            proxy.scrollTo("topAnchor", anchor: .top)
                        }
                    }
                }
                
                
                VStack {
                    
                    Spacer()
                    
                    HStack{
                        
                        LoginButtonsSection
                        
                    }
                    
                }
                
                ForEach(0..<generateNavigationLinks(homeviewModel: homeviewModel).count, id: \.self) { index in
                    generateNavigationLinks(homeviewModel: homeviewModel)[index]
                }
            }
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    triggerScrollHintShake()
                }
            }
            .onAppear {
                triggerScrollHintShake()
                Task {
                    CustomFirebaseAnalytics.shared.logEvent(title: "revamped_landing_onappear", contentType: contentType)

                    if let fetchedHoliday = await holidayViewModel.fetchHoliday() {
                        holiday = fetchedHoliday
                    }
                    viewModel.fetchEnableBiometric()
                    
                    await fetchPublicKey()
                    Constants.deviceId = UIDevice.current.identifierForVendor?.uuidString ?? ""
                    authenticationViewModel.saveFirstTime(firstTime: true)
                    
                    await authenticationViewModel.fetchPublicKey(
                        onSuccess: {  publicKeyEntity in
                            CustomFirebaseAnalytics.shared.logEvent(title: "fetch_key_success", contentType: contentType)
                        },
                        onFailure: { error in
                            CustomFirebaseAnalytics.shared.logError(message: "fetch_key_failed", screen: screen)
                            dialogEntity = DialogEntity(
                                title: "Connection timed out or lost.",
                                message: error,
                                icon: "error"
                            )
                            confirmButtonText = "Retry"
                            dismissButtonText = "Cancel"
                        }
                    )
                    
                    let _ = loginViewmodel.encryptDeviceID()
                    let _ = loginViewmodel.encryptChannel()
                    
                    fetchForexRates()
                }
            }
            .onChange(of: newtworkMonitor.isConnected){ newValue in
                if newValue {
                    Task {
                        await authenticationViewModel.fetchPublicKey(
                            onSuccess: {  publicKeyEntity in
                                CustomFirebaseAnalytics.shared.logEvent(title: "fetch_key_success", contentType: contentType)
                            },
                            onFailure: { error in
                                CustomFirebaseAnalytics.shared.logError(message: "fetch_key_failed", screen: screen)

                                dialogEntity = DialogEntity(
                                    title: "Connection timed out or lost.",
                                    message: error,
                                    icon: "error"
                                )
                                confirmButtonText = "Retry"
                                dismissButtonText = "Cancel"
                                isShowAlertDialog = true
                            }
                        )
                    }
                }
            }
            .refreshable {
                Task{
                    CustomFirebaseAnalytics.shared.logEvent(title: "refresh", contentType: contentType)

                    await authenticationViewModel.fetchPublicKey(
                        onSuccess: { publicKeyEntity in
                            CustomFirebaseAnalytics.shared.logEvent(title: "fetch_key_success", contentType: contentType)

                        },
                        onFailure: { error in
                            CustomFirebaseAnalytics.shared.logError(message: "fetch_key_failed", screen: screen)
                            dialogEntity = DialogEntity(
                                title: "Connection timed out or lost.",
                                message: error,
                                icon: "error"
                            )
                            confirmButtonText = "Retry"
                            dismissButtonText = "Cancel"
                            isShowAlertDialog = true
                        }
                    )
                }
            }
            .toastView(toast: $toast)
            .fullScreenProgressOverlay(isShowing: (registerViewModel.state == .isLoading) ||
                                       (loginViewmodel.state == .isLoading) ||
                                       (registerViewModel.state == .isLoading), text: "Loading...")
            .overlay{
                MyAlertDialog(
                    isPresented: $isShowAlertDialog,
                    title: dialogEntity.title,
                    text: dialogEntity.message,
                    confirmButtonText: confirmButtonText,
                    dismissButtonText: dismissButtonText,
                    imageName: dialogEntity.icon,
                    onDismiss: {
                        isShowAlertDialog = false
                        if dialogEntity.message.contains("It looks like you've signed in on a new"){
                            authenticationViewModel.signIn()
                        }
                    },
                    onConfirmation: {
                        if dialogEntity.message.contains("Connection lost or timed out. Please try again"){
                            Task {
                                
                                await authenticationViewModel.fetchPublicKey(
                                    onSuccess: { publicKeyEntity in
                                        self.isPublicKeyFetched = publicKeyEntity.publicKey.isEmpty == false
                                        CustomFirebaseAnalytics.shared.logEvent(title: "fetch_key_success", contentType: contentType)
                                    },
                                    onFailure: { error in
                                        CustomFirebaseAnalytics.shared.logError(message: "fetch_key_failed", screen: screen)

                                        dialogEntity = DialogEntity(
                                            title: "Connection timed out or lost.",
                                            message: error,
                                            icon: "error"
                                        )
                                        confirmButtonText = "Retry"
                                        dismissButtonText = "Cancel"
                                        isShowAlertDialog = true
                                    }
                                )
                            }
                        }
                        if dialogEntity.message.contains("A new version of the app is available."){
                            CustomFirebaseAnalytics.shared.logEvent(title: "tapped_update_app_button", contentType: contentType)

                            Task {
                                let bundleIdentifier = Bundle.main.bundleIdentifier ?? ""
                                if let url = URL(string: Constants.APPLE_APP_URL) {
                                    await UIApplication.shared.open(url)
                                }
                            }
                        }
                        
                        if dialogEntity.message.contains("Please use the unlock feature under Self Service"){
                            print("DEBUG: Acc locked, so navigate to unlock user.")
                            CustomFirebaseAnalytics.shared.logEvent(title: "navigate_to_unlock_user", contentType: contentType)
                            viewModel.isNavigateToUnlockUserView = true
                        }
                        
                        if dialogEntity.message.contains("It looks like you've signed in on a new"){
                            CustomFirebaseAnalytics.shared.logEvent(title: "new_device_navigate_to_unlock_user", contentType: contentType)
                            viewModel.isNavigateToOneSecurityQuestionView = true
                        }
                        
                        
                        if dialogEntity.message.contains("Dear Customer, the details provided don’t match our records."){
                            isShowAlertDialog = false
                        }
                        if dialogEntity.message.contains("It seems like your request did not go through."){
                            isShowAlertDialog = false
                        }
                        if dialogEntity.message.contains("please set up your security questions now"){
                            CustomFirebaseAnalytics.shared.logEvent(title: "set_sqs_navigate_to_set_sqs", contentType: contentType)

                            isShowAlertDialog = false
                            isNavigateToSetAllSecurityQuestionsView = true
                        }
                    }
                )
                
            }
            
            .fullScreenProgressOverlay(isShowing: registerViewModel.state == FetchState.isLoading, text: "Loading...")
            .sheet(isPresented: $isShowDiscoverCards) {
                SafariView(url: URL(string: "https://goodhome.co.ke/")!)
            }
            .sheet(isPresented: $isNavigateKingdomScreen) {
                SafariView(url: URL(string: "https://kingdomsecurities.co.ke/")!)
            }
            .sheet(isPresented: $isNavigateBancassuranceScreen) {
                SafariView(url: URL(string: "https://insurance.co-opbank.co.ke/#cta-banc")!)
            }
            .sheet(isPresented: $isNavigateAssetScreen) {
                SafariView(url: URL(string: "https://assetfinance.co-opbank.co.ke/")!)
            }
            .sheet(isPresented: $isNavigateCooploanScreen) {
                SafariView(url: URL(string: "https://www.co-opbank.co.ke/personal-banking/borrow/")!)
            }
            .sheet(isPresented: $isNavigatemsmeScreen) {
                SafariView(url: URL(string: "https://msme.co-opbank.co.ke/")!)
            }
            .sheet(isPresented: $isNavigatediasporaScreen) {
                SafariView(url: URL(string: "https://diaspora.co-opbank.co.ke/")!)
            }
            .sheet(isPresented: $isNavigateCoopCards) {
                SafariView(url: URL(string: "https://www.co-opbank.co.ke/personal-banking/cards/")!)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .ignoresSafeArea(edges: .bottom)
        .alert("Permission Required", isPresented: $isShowPermissionAlert) {
            Button("Settings", role: .none) {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text(permissionAlertMessage)
        }
    }
    
    private func handleOpenAccountTapped() {
        appLocationManager.requestWhenInUseAuthorization(
            onLocationPermissionEnabled: {
                
                // Location granted, now request camera
                AppCameraPermissionManager.shared.requestCameraPermission(
                    onCameraPermissionEnabled: {
                        Task {
                            // Both permissions granted
                            await saveDeviceDetailsAndMore(
                                onSuccess: {
                                    isNavigateToOpenAccountView = true
                                    // isNavigateToNewOpenAccountWebView = true
                                },
                                onFailure: { error in
                                    
                                }
                            )
                        }
                        
                    },
                    onCameraPermissionDisabled: {
                        // Camera denied
                        showPermissionAlert(message: "Camera permission is required to open an account. Please enable it in Settings.")
                    }
                )
            },
            onLocationPermissionDisabled: {
                // Location denied
                showPermissionAlert(message: "Location permission is required to open an account. Please enable it in Settings.")
            }
        )
    }
    
    private func showPermissionAlert(message: String) {
        permissionAlertMessage = message
        isShowPermissionAlert = true
    }
    
    func fetchPublicKey() async {
        await authenticationViewModel.fetchPublicKey(
            onSuccess: { publicKeyEntity in
                self.isPublicKeyFetched = publicKeyEntity.publicKey.isEmpty == false
            },
            onFailure: { error in
                dialogEntity = DialogEntity(
                    title: "Connection timed out or lost.",
                    message: error,
                    icon: "error"
                )
                confirmButtonText = "Retry"
                dismissButtonText = "Cancel"
                isShowAlertDialog = true
            }
        )
    }
    
    func saveDeviceDetails() async {
        await registerViewModel.saveDeviceDetails(
            deviceID: UIDevice.current.identifierForVendor?.uuidString ?? "N/A",
            deviceName: UIDevice.current.name.removingEmojis(),
            deviceType: UIDevice.current.userInterfaceIdiom == .phone ? "iPhone" : "iPad",
            accessPoint: "7",
            journeyType: "NEW_TO_COOPBANK",
            latitude:"\(appLocationManager.latitude)",
            longitude:"\(appLocationManager.longitude)",
            osVersion: UIDevice.current.systemVersion,
            platform: "iOS",
            apkVersion: "\(appVersion)",
            onsuccess: { deviceDetailsResponseModel in
                print("DEBUG: saveDeviceDetails success.")
                accountTypesViewModel.isMcoopCashOnboarding = true
                
                if isOpenWalletClicked == true{
                    isNavigateToIdentityDetailsView = false
                    isNavigateToAccountTypesView = false
                    // sheetComponent = "digitalWalletSheetView"
                    // sheetState = true
                    isOpenWalletClicked = false
                    
                } else if isOpenAccountClicked == true{
                    isNavigateToIdentityDetailsView = false
                    isNavigateToAccountTypesView = true // Navigate to account types selection
                    
                    // sheetComponent = ""
                    // sheetState = false
                    isOpenAccountClicked = false
                    
                }
                else if isRegisterClicked == true{
                    isNavigateToIdentityDetailsView = true // Naviagat to key in details for
                    isNavigateToAccountTypesView = false
                    onboardingJourneyType =  OnboardingJourneyType.normalOnboarding
                    
                    // sheetComponent = ""
                    // sheetState = false
                    isRegisterClicked = false
                    isOpenAccountClicked = false
                }
                else {
                    // sheetComponent = ""
                    //sheetState = false
                    
                    isNavigateToAccountTypesView = false
                    isNavigateToIdentityDetailsView = true
                    
                }
                
                print("DEBUG: saveDeviceDetails \(isNavigateToAccountTypesView), \(isNavigateToIdentityDetailsView)")
                
            },
            onfailure: { error in
                print("DEBUG: saveDeviceDetails error.")
                dialogEntity = DialogEntity(title: "Oops", message: error, icon: "error")
                isShowAlertDialog = true
            }
        )
    }
    
    
    func generateNavigationLinks(homeviewModel: HomeviewModel) -> [NavigationLink<EmptyView, AnyView>] {
        return [
            NavigationLink(
                destination: AnyView(RevampedMpinView().navigationBarBackButtonHidden()),
                isActive: $isNavigateToMpin
            ) { EmptyView() },
            
            NavigationLink(
                destination: AnyView(RevampedUsernameView().navigationBarBackButtonHidden()),
                isActive: $isNavigateToUsernamePassword
            ) { EmptyView() },
            
            NavigationLink(
                destination: AnyView(ForexScreen().navigationBarBackButtonHidden()),
                isActive: $isNavigateToForex
            ) { EmptyView() },
            
            NavigationLink(
                destination: AnyView(ChatBotScreenView().navigationBarBackButtonHidden()),
                isActive: $isNavigateToChatbot
            ) { EmptyView() },
            NavigationLink(
                destination: AnyView(
                    RevampedSelfServiceView(
                        userUnlockedSuccessfully: {
                            isNavigateToSelfService = false
                        }
                    ).navigationBarBackButtonHidden()
                ),
                isActive: $isNavigateToSelfService
            ) { EmptyView() },
            
            NavigationLink(
                destination: AnyView(OnboardingRequrementsView().navigationBarBackButtonHidden()),
                isActive: $isNavigateToOpenAccountView
            ) { EmptyView() },
            NavigationLink(
                destination: AnyView(NewOpenAccountWebView().navigationBarBackButtonHidden()),
                isActive: $isNavigateToNewOpenAccountWebView
            ) { EmptyView() },
            NavigationLink(
                destination: AnyView(CustomerDetailsView(
                    onboardingJourneyType: onboardingJourneyType
                ).navigationBarBackButtonHidden()),
                isActive: $isNavigateToCustomerDetailsView
            ) { EmptyView() },
            
            NavigationLink(
                destination: AnyView(SetAllSecurityQuestionsView(
                    onSuccesss: {
                        idNumber = viewModel.user?.idNo ?? ""
                        authenticationViewModel.signIn()
                    }
                ).navigationBarBackButtonHidden()),
                isActive: $isNavigateToSetAllSecurityQuestionsView
            ) { EmptyView() },
            
            
            NavigationLink(
                destination: AnyView(OneSecurityQuestionView(
                    idNumber: viewModel.user?.idNo ?? "",
                    headTitle: "Set Up MPin"
                ).navigationBarBackButtonHidden()),
                isActive: $viewModel.isNavigateToOneSecurityQuestionView
            ) { EmptyView() }
            
            
        ]
        
    }
    
    var appName: String {
        return Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "Unknown"
    }
    
    var appVersion: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }
    
    private func requestPhotoLibraryAccess() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { newStatus in
                if newStatus == .authorized {
                    print("DEBUG: PhotoLibraryAccess Access granted.")
                } else {
                    print("DEBUG: PhotoLibraryAccess Access denied.")
                }
            }
        case .restricted, .denied:
            print("DEBUG: PhotoLibraryAccess Access denied or restricted.")
        case .authorized:
            print("DEBUG: PhotoLibraryAccess Access already granted.")
        case .limited:
            print("DEBUG: PhotoLibraryAccess Access limited.")
        @unknown default:
            print("DEBUG: PhotoLibraryAccess Unknown authorization status.")
        }
    }
    
    func fetchForexRates(){
        Task{
            await forexRatesViewModel.fetchForexRates()
            
            var kenyanSell: [ForexModel] {
                if let response = forexRatesViewModel.forexResponse {
                    return response.filter { $0.fromCurrency == "KES" }
                }
                return []
            }
            
            var kenyanBuy: [ForexModel] {
                if let response = forexRatesViewModel.forexResponse {
                    return response.filter { $0.toCurrency == "KES" }
                }
                return []
            }
            
            var comprehensiveCurrency: [CleanedForexRate] {
                let mappedRates = kenyanBuy.map { item in
                    let matchingItem = kenyanSell.first { $0.toCurrency == item.fromCurrency }
                    return CleanedForexRate(
                        fromCurrency: item.fromCurrency ?? "",
                        toCurrency: item.toCurrency ?? "",
                        rate: item.rate ?? "",
                        buyRate: Double(item.exchangeRate ?? "") ?? 0.0,
                        sellRate: matchingItem?.exchangeRate?.toDouble() ?? 0.0,
                        serialNum: Int(item.serialNum ?? "") ?? 0
                    )
                }
                let uniqueRates = Dictionary(grouping: mappedRates, by: { $0.fromCurrency })
                    .compactMap { $0.value.first }
                return uniqueRates
            }
            forexRatesViewModel.cleanedResponse = comprehensiveCurrency
        }
    }
    
    func saveDeviceDetailsAndMore(
        onSuccess: @escaping  () -> Void,
        onFailure: @escaping  (String) -> Void
    ) async {
        await registerViewModel.saveDeviceDetails(
            deviceID: UIDevice.current.identifierForVendor?.uuidString ?? "N/A",
            deviceName: UIDevice.current.name.removingEmojis(),
            deviceType: UIDevice.current.userInterfaceIdiom == .phone ? "iPhone" : "iPad",
            accessPoint: "7",
            journeyType: "NEW_TO_COOPBANK",
            latitude:"\(appLocationManager.latitude)",
            longitude:"\(appLocationManager.longitude)",
            osVersion: UIDevice.current.systemVersion,
            platform: "iOS",
            apkVersion: "\(appVersion)",
            onsuccess: { deviceDetailsResponseModel in
                onSuccess()
            },
            onfailure: { error in
                onFailure(error)
                print("DEBUG: saveDeviceDetails error.")
                dialogEntity = DialogEntity(title: "Oops", message: error, icon: "error")
                confirmButtonText = ""
                dismissButtonText = "Okay"
                isShowAlertDialog = true
            }
        )
    }
    
    func triggerScrollHintShake() {
        let highAmplitude: CGFloat = 22   // strong first shakes
        let lowAmplitude: CGFloat = 8     // soft ending bounce
        let duration: Double = 0.5
        
        let amplitudes: [CGFloat] = [
            highAmplitude, -highAmplitude,   // 1st shake (strong)
            //            highAmplitude, -lowAmplitude,   // 2nd shake (strong)
            //            lowAmplitude, -lowAmplitude,     // 3rd shake (soft)
            lowAmplitude, -lowAmplitude      // 4th shake (soft)
        ]
        
        for i in amplitudes.indices {
            DispatchQueue.main.asyncAfter(deadline: .now() + duration * Double(i)) {
                withAnimation(.easeInOut(duration: duration)) {
                    scrollHintOffset = amplitudes[i]
                }
            }
        }
        
        // settle back naturally
        DispatchQueue.main.asyncAfter(deadline: .now() + duration * Double(amplitudes.count)) {
            withAnimation(.interpolatingSpring(stiffness: 180, damping: 18)) {
                scrollHintOffset = 0
            }
        }
    }
}


#Preview {
    RevampedLandingScreen()
}
