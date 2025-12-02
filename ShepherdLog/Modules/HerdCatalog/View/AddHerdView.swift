import SwiftUI

struct AddHerdView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var viewModel: HerdCatalogViewModel
    
    @State var herd: Herd
    
    @FocusState var focused: Bool
    
    var body: some View {
        ZStack {
            Color.slBrown
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                navigation
                background
                    .overlay {
                        VStack(spacing: 20) {
                            VStack(spacing: 12) {
                                title
                                animalTypeSelector
                            }
                            
                            herdNumberInput
                            saveButton
                        }
                        .padding(.vertical, 36)
                        .padding(.horizontal, 16)
                        .background(.slSuperCream)
                        .cornerRadius(24)
                        .overlay {
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(.slBrown, lineWidth: 4)
                        }
                        .padding(.top, 50)
                        .padding(.horizontal, 16)
                        .frame(maxHeight: .infinity, alignment: .top)
                    }
                    .toolbar {
                        ToolbarItem(placement: .keyboard) {
                            Button("Done") {
                                focused = false
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .navigationBarBackButtonHidden()
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
    
    private var title: some View {
        Text("Add Herd")
            .font(.oto(with: 32))
            .foregroundStyle(.slBrown)
    }
    
    private var animalTypeSelector: some View {
        VStack(spacing: 14) {
            Text("Select animals herd:")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.oto(with: 20))
                .foregroundStyle(.slBrown)
            
            HStack {
                ForEach(HerdType.allCases) { type in
                    Button {
                        herd.type = type
                    } label: {
                        VStack(spacing: 0) {
                            Image(type.icon)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 50)
                                .clipped()
                                .background(.slLightBrown)
                                .cornerRadius(20)
                            
                            Text(type.title)
                                .font(.oto(with: 12))
                                .foregroundStyle(herd.type == type ? .white : .slSuperCream)
                        }
                        .padding(.top, 4)
                        .padding(.horizontal, 4)
                        .padding(.bottom, 10)
                        .background(
                            herd.type == type ?
                            LinearGradient(
                                colors: [
                                    .yellow,
                                    .slOrange
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            ) :
                                LinearGradient(
                                    colors: [.slBrown],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                        )
                        .cornerRadius(20)
                    }
                }
            }
        }
    }
    
    private var herdNumberInput: some View {
        VStack(spacing: 12) {
            Text("Specify the number in the herd:")
                .font(.oto(with: 20))
                .foregroundStyle(.slBrown)
                .multilineTextAlignment(.leading)
            
            CustomTextField(
                text: $herd.number,
                placeholder: "Enter number...",
                keyboardType: .numberPad,
                focused: $focused
            )
        }
    }
    
    private var saveButton: some View {
        Button {
            viewModel.save(herd)
        } label: {
            Image(.Images.buttonBG)
                .resizable()
                .scaledToFit()
                .overlay {
                    Text("Save")
                        .font(.oto(with: 22))
                        .foregroundStyle(.slBrown)
                        .offset(y: -5)
                        .opacity(herd.isReadyToSave ? 1 : 0.7)
                }
                .disabled(!herd.isReadyToSave)
        }
    }
}

#Preview {
    AddHerdView(herd: Herd(isReal: false))
        .environmentObject(HerdCatalogViewModel())
}

#Preview {
    AddHerdView(herd: Herd(isReal: true))
        .environmentObject(HerdCatalogViewModel())
}
