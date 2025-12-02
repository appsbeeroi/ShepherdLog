import SwiftUI

struct AddHealthView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var viewModel: HealthViewModel
    
    @State var health: HealthNote
    
    @State var hasDateSelected: Bool
    
    @State private var isShowDatePicker = false
    
    @FocusState var focused: Bool
    
    var body: some View {
        ZStack {
            Color.slBrown
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                navigation
                background
                    .overlay {
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 20) {
                                title
                                
                                VStack(spacing: 12) {
                                    dateInput
                                    herdTypeSelector
                                    statusInput
                                    saveButton
                                }
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
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .disabled(isShowDatePicker)
            
            if isShowDatePicker {
                datePicker
            }
        }
        .navigationBarBackButtonHidden()
        .animation(.default, value: isShowDatePicker)
        .onChange(of: health.date) { _ in
            hasDateSelected = true
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
    
    private var title: some View {
        Text("Add daily Herd")
            .font(.oto(with: 32))
            .foregroundStyle(.slBrown)
    }
    
    private var herdTypeSelector: some View {
        VStack(spacing: 14) {
            Text("Select animals herd:")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.oto(with: 20))
                .foregroundStyle(.slBrown)
            
            HStack {
                ForEach(HerdType.allCases) { type in
                    Button {
                        health.type = type
                    } label: {
                        VStack(spacing: 0) {
                            Image(type.icon)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 60)
                                .clipped()
                                .background(.slLightBrown)
                                .cornerRadius(20)
                            
                            Text(type.title)
                                .font(.oto(with: 12))
                                .foregroundStyle(health.type == type ? .white : .slSuperCream)
                        }
                        .padding(.top, 4)
                        .padding(.horizontal, 4)
                        .padding(.bottom, 10)
                        .background(
                            health.type == type ?
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
    
    private var dateInput: some View {
        VStack(spacing: 12) {
            Text("Specify the date")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.oto(with: 20))
                .foregroundStyle(.slBrown)
                .multilineTextAlignment(.leading)
            Button {
                isShowDatePicker.toggle()
            } label: {
                let time = health.date.formatted(.dateTime.hour().minute())
                Text(hasDateSelected ? time : "Enter date")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.oto(with: 20))
                    .foregroundColor(.slSuperCream)
            }
            .frame(height: 60)
            .padding(.horizontal, 16)
            .background(.slLightBrown)
            .cornerRadius(24)
            .overlay {
                RoundedRectangle(cornerRadius: 24)
                    .stroke(.slBrown, lineWidth: 4)
            }
        }
    }
    
    private var statusInput: some View {
        VStack(spacing: 12) {
            Text("Write the health status of the animals:")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.oto(with: 20))
                .foregroundStyle(.slBrown)
                .multilineTextAlignment(.leading)
            
            CustomTextField(
                text: $health.status,
                placeholder: "Enter notes...",
                keyboardType: .default,
                focused: $focused
            )
        }
    }
    
    private var saveButton: some View {
        Button {
            viewModel.save(health)
        } label: {
            Image(.Images.buttonBG)
                .resizable()
                .scaledToFit()
                .overlay {
                    Text("Save")
                        .font(.oto(with: 22))
                        .foregroundStyle(.slBrown)
                        .offset(y: -5)
                        .opacity(health.isReadyToSave ? 1 : 0.7)
                }
                .disabled(!health.isReadyToSave)
        }
    }
    
    private var datePicker: some View {
        ZStack {
            Color.black
                .opacity(0.4)
                .ignoresSafeArea()
            
            VStack {
                Button("Done") {
                    isShowDatePicker = false
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                DatePicker("", selection: $health.date, displayedComponents: [.date])
                    .labelsHidden()
                    .datePickerStyle(.graphical)
            }
            .padding()
            .background(.slSuperCream)
            .tint(.slBrown)
            .cornerRadius(20)
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    AddHealthView(health: HealthNote(isReal: false), hasDateSelected: false)
}

#Preview {
    AddHealthView(health: HealthNote(isReal: true), hasDateSelected: true)
}
