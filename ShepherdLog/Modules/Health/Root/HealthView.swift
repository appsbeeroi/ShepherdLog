import SwiftUI

struct HealthView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var viewModel = HealthViewModel()
    
    @State private var isShowRemoveAlert = false
    
    @State private var healthToRemove: HealthNote?
    
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
                                    healthes
                                }
                                .padding(.top, 50)
                                .padding(.horizontal, 16)
                            }
                    }
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
                
                if isShowRemoveAlert {
                    removeAlert
                }
            }
            .animation(.easeInOut, value: viewModel.healthes)
            .animation(.easeInOut, value: isShowRemoveAlert)
            .navigationDestination(for: HealthScreen.self) { screen in
                switch screen {
                    case .add(let health):
                        AddHealthView(health: health, hasDateSelected: health.isReadyToSave)
                }
            }
            .onAppear {
                healthToRemove = nil
                viewModel.downloadHealthes()
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
            
            Text("Animal Health")
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
            viewModel.navPath.append(.add(HealthNote(isReal: true)))
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
                    Text("Add record")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.oto(with: 20))
                    
                    Text("Create a card for each herd and record your health status.")
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
                                guard let healthToRemove else { return }
                                viewModel.remove(healthToRemove)
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
    
    private var healthes: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.healthes) { health in
                    Button {
                        viewModel.navPath.append(.add(health))
                    } label: {
                        HStack {
                            if let type = health.type {
                                Image(type.icon)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 90, height: 90)
                                    .clipped()
                                
                                VStack(spacing: 6) {
                                    Text("\(type.title) Herd")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .font(.oto(with: 20))
                                    
                                    Text(health.status)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .font(.oto(with: 10))
                                        .multilineTextAlignment(.leading)
                                }
                                .frame(maxHeight: .infinity, alignment: .top)
                                .padding(.vertical, 16)
                                
                                Text(health.date.formatted(.dateTime.month(.abbreviated).day()))
                                    .font(.oto(with: 10))
                                    .frame(maxHeight: .infinity, alignment: .top)
                                    .padding(.vertical, 16)
                            }
                        }
                        .padding(.trailing, 16)
                        .frame(minHeight: 100)
                        .background(.slLightBrown)
                        .foregroundStyle(.slSuperCream)
                        .cornerRadius(24)
                        .overlay {
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(.slBrown, lineWidth: 4)
                        }
                        .contextMenu {
                            Button {
                                healthToRemove = health
                                isShowRemoveAlert.toggle()
                            } label: {
                                Label("Remove", systemImage: "trash")
                            }
                        }
                    }
                }
            }
            .padding(.top, 3)
            .padding(.horizontal, 2)
        }
    }
}

#Preview {
    HealthView()
}
