import SwiftUI

struct MainFlowView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var isShowHerdCatalog = false
    @State private var isShowTracker = false
    @State private var isShowAnimalHealth = false
    
    var body: some View {
        ZStack {
            Color.slBrown
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                navigation
                
                ForEach(MainScreenFlowType.allCases) { type in
                    Button {
                        switch type {
                            case .catalog:
                                isShowHerdCatalog.toggle()
                            case .health:
                                isShowAnimalHealth.toggle()
                            case .tracker:
                                isShowTracker.toggle()
                        }
                    } label: {
                        Image(type.image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width)
                    }
                }
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .navigationBarBackButtonHidden()
        .fullScreenCover(isPresented: $isShowHerdCatalog) {
            HerdCatalogView()
        }
        .fullScreenCover(isPresented: $isShowTracker) {
            TrackerView()
        }
        .fullScreenCover(isPresented: $isShowAnimalHealth) {
            HealthView()
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
}

#Preview {
    MainFlowView()
}
