import SwiftUI

struct SettingsView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @AppStorage("turnOn") var turnOn = false
    
    @State private var isToggleOn = false
    @State private var isShowRemoveAlert = false
    @State private var isShowWeb = false
    @State private var isShowNotificationAlert = false
        
    var body: some View {
        ZStack {
            Color.slBrown
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                navigation
                
                ZStack {
                    background
                    tableImage
                        .overlay {
                            VStack(spacing: 16) {
                                title
                                notificationLabel
                                otherFuctions
                            }
                            .offset(y: 40)
                        }
                }
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            #warning("cссылка")
            if isShowWeb,
               let url = URL(string: "https://www.apple.com") {
                WebView(url: url) {
                    isShowWeb = false
                }
                .ignoresSafeArea(edges: [.bottom])
            }
        }
        .onAppear {
            isToggleOn = turnOn
        }
        .alert("The permission denied. Open settings?", isPresented: $isShowNotificationAlert) {
            Button("Open") {
                guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
                if UIApplication.shared.canOpenURL(settingsURL) {
                    UIApplication.shared.open(settingsURL)
                }
            }
            
            Button("No") {
                isToggleOn = false
            }
        }
        .onChange(of: isToggleOn) { isToggleOn in
            switch isToggleOn {
                case true:
                    Task {
                        switch await NotificationPermissionManager.shared.currentStatus {
                            case .allowed:
                                turnOn = true
                            case .denied:
                                isShowNotificationAlert = true
                            case .undetermined:
                                await NotificationPermissionManager.shared.requestAuthorization()
                        }
                    }
                case false:
                    turnOn = false
            }
        }
    }
    
    private var navigation: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(.Images.buttonBG)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 70)
                    .overlay {
                        Text("Back")
                            .font(.oto(with: 12))
                            .foregroundStyle(.black)
                    }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
    }
    
    private var background: some View {
        GeometryReader { geo in
            Image(.Images.bgMain)
                .resizable()
                .scaledToFill()
                .frame(width: geo.size.width, height: geo.size.height)
                .clipped()
        }
        .ignoresSafeArea(edges: [.bottom])
        .allowsHitTesting(false)
    }
    
    private var tableImage: some View {
        Image(.Images.settingsPannel)
            .resizable()
            .scaledToFit()
            .padding(.horizontal, 30)
            .offset(y: -30)
    }
    
    private var title: some View {
        Text("Settings")
            .font(.oto(with: 32))
            .foregroundStyle(.white)
    }
    
    private var notificationLabel: some View {
        HStack {
            VStack(spacing: 0) {
                Text("Notification")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.oto(with: 20))
                    
                Text("reminders about pastures, checks, and herd rest")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.oto(with: 10))
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }
            .foregroundStyle(.white)
            
            notificationToggle
        }
        .padding(.horizontal, 70)
    }
    
    private var notificationToggle: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 48)
                .frame(width: 120, height: 46)
                .foregroundStyle(.white)
                .overlay {
                    RoundedRectangle(cornerRadius: 48)
                        .stroke(.slBrown, lineWidth: 3)
                }
                .overlay {
                    HStack {
                        RoundedRectangle(cornerRadius: 48)
                            .frame(width: 53, height: 34)
                            .foregroundStyle(.slBrown)
                    }
                    .padding(.horizontal, 6)
                    .frame(maxWidth: .infinity, alignment: isToggleOn ? .leading : .trailing)
                }
            
            HStack(spacing: 2) {
                Button {
                    isToggleOn = true
                } label: {
                    Text("On")
                        .frame(width: 53)
                        .font(.oto(with: 16))
                        .foregroundStyle(isToggleOn ? .slCrema : .slBrown)
                }
                
                Button {
                    isToggleOn = false
                } label: {
                    Text("Off")
                        .frame(width: 53)
                        .font(.oto(with: 16))
                        .foregroundStyle(isToggleOn ? .slBrown : .slCrema)
                }
            }
        }
        .animation(.smooth, value: isToggleOn)
    }
    
    private var removeAlert: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            Image(.Images.basePannel)
                .resizable()
                .scaledToFit()
                .padding(.horizontal)
                .overlay {
                    VStack(spacing: 12) {
                        Text("Want to remove\nthe herd?")
                            .font(.oto(with: 24))
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                        
                        VStack(spacing: 8) {
                            Button {
                                Task {
                                    async let _ = await DefaultsService.shared.clear(for: .daily)
                                    async let _ = await DefaultsService.shared.clear(for: .health)
                                    async let _ = await DefaultsService.shared.clear(for: .herds)
                                }
                            } label: {
                                Image(.Images.buttonBG)
                                    .resizable()
                                    .scaledToFit()
                                    .padding(.horizontal, 50)
                                    .overlay {
                                        Text("Yes")
                                            .font(.oto(with: 22))
                                            .foregroundStyle(.slBrown)
                                            .offset(y: -5)
                                    }
                            }
                            
                            Button {
                                isShowRemoveAlert = false
                            } label: {
                                Image(.Images.buttonBG)
                                    .resizable()
                                    .scaledToFit()
                                    .padding(.horizontal, 50)
                                    .overlay {
                                        Text("No")
                                            .font(.oto(with: 22))
                                            .foregroundStyle(.slBrown)
                                            .offset(y: -5)
                                    }
                            }
                        }
                    }
                }
        }
    }
    
    private var otherFuctions: some View {
        VStack(spacing: 8) {
            Text("Other functions")
                .font(.oto(with: 20))
                .foregroundStyle(.white)
            
            Button {
                isShowRemoveAlert.toggle()
            } label: {
                Image(.Images.buttonBG)
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 60)
                    .overlay {
                        Text("Clear app data")
                            .font(.oto(with: 22))
                            .foregroundStyle(.slBrown)
                            .offset(y: -5)
                    }
            }
            
            Button {
                isShowWeb.toggle()
            } label: {
                Image(.Images.buttonBG)
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 60)
                    .overlay {
                        Text("About the App")
                            .font(.oto(with: 22))
                            .foregroundStyle(.slBrown)
                            .offset(y: -5)
                    }
            }
        }
    }
}


#Preview {
    SettingsView()
}
