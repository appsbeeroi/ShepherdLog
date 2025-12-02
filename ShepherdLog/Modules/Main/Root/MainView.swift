import SwiftUI

struct MainView: View {
    
    @State private var isShowFlowView = false
    @State private var isShowSettings = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image(.Images.Main.mainViewBG)
                    .resizeImage()
                
                VStack {
                    VStack(spacing: 8) {
                        Button {
                            isShowFlowView.toggle()
                        } label: {
                            Image(.Images.buttonBG)
                                .resizable()
                                .scaledToFit()
                                .padding(.horizontal, 22)
                                .overlay {
                                    Text("Start")
                                        .font(.oto(with: 32))
                                        .foregroundStyle(.black)
                                }
                        }
                        
                        Button {
                            isShowSettings.toggle()
                        } label: {
                            Image(.Images.buttonBG)
                                .resizable()
                                .scaledToFit()
                                .padding(.horizontal, 72)
                                .overlay {
                                    Text("Settings")
                                        .font(.oto(with: 22))
                                        .foregroundStyle(.black)
                                }
                        }
                    }
                    .padding(.bottom, 80)
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
            .navigationDestination(isPresented: $isShowFlowView) {
                MainFlowView()
            }
            .fullScreenCover(isPresented: $isShowSettings) {
                SettingsView()
            }
        }
    }
}

#Preview {
    MainView()
}
