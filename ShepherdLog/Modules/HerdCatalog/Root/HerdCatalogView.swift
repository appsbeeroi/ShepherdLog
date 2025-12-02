import SwiftUI

struct HerdCatalogView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var viewModel = HerdCatalogViewModel()
    
    @State private var isShowRemoveAlert = false
    @State private var herdToRemove: Herd?
    
    var body: some View {
        NavigationStack(path: $viewModel.navPath) {
            ZStack {
                Color.slBrown
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    navigation
                    
                    ZStack {
                        background
                            .overlay {
                                VStack(spacing: 32) {
                                    addButton
                                    herds
                                }
                                .padding(.top, 50)
                                .padding(.horizontal, 16)
                            }
                    }
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
                .disabled(isShowRemoveAlert)
                
                if isShowRemoveAlert {
                    removeAlert
                }
            }
            .animation(.easeInOut, value: viewModel.herds)
            .animation(.easeInOut, value: isShowRemoveAlert)
            .navigationDestination(for: HerdCatalogScreen.self) { screen in
                switch screen {
                    case .add(let herd):
                        AddHerdView(herd: herd)
                }
            }
            .onAppear {
                herdToRemove = nil
                viewModel.downloadHerds()
            }
        }
        .environmentObject(viewModel)
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
            
            Text("Herd Catalog")
                .frame(maxWidth: .infinity, alignment: .trailing)
                .font(.oto(with: 20))
                .foregroundStyle(.slCrema)
        }
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
    
    private var addButton: some View {
        Button {
            viewModel.navPath.append(.add(Herd(isReal: true)))
        } label: {
            HStack(spacing: 12) {
                Circle()
                    .frame(width: 57, height: 57)
                    .foregroundStyle(.slLightGreen)
                    .overlay {
                        ZStack {
                            Circle()
                                .stroke(.slDarkGreen, lineWidth: 3)
                            
                            Image(systemName: "plus")
                                .font(.system(size: 30, weight: .medium))
                                .foregroundStyle(.slDarkGreen)
                        }
                    }
                
                VStack(spacing: 0) {
                    Text("Add Herd")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.oto(with: 20))
                    
                    Text("Create a card for each herd and record your animals.")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.oto(with: 10))
                        .multilineTextAlignment(.leading)
                }
                .foregroundStyle(.slBrown)
            }
            .frame(height: 88)
            .padding(.horizontal, 16)
            .background(.slSuperCream)
            .cornerRadius(24)
            .overlay {
                RoundedRectangle(cornerRadius: 24)
                    .stroke(.slBrown, lineWidth: 4)
            }
        }
    }
    
    private var herds: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(
                columns: [
                    GridItem(spacing: 10),
                    GridItem(spacing: 10)
                ],
                spacing: 16) {
                    ForEach(viewModel.herds) { herd in
                        HerdCellView(herd: herd) {
                            viewModel.navPath.append(.add(herd))
                        } removeAction: {
                            herdToRemove = herd
                            isShowRemoveAlert.toggle()
                        }
                    }
                }
                .padding(.top, 5)
                .padding(.horizontal, 2)
        }
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
                                guard let herdToRemove else { return }
                                viewModel.remove(herdToRemove)
                                isShowRemoveAlert = false
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
}

#Preview {
    HerdCatalogView()
}


