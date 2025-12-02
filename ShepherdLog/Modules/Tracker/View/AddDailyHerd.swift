import SwiftUI


struct AddDailyHerd: View {
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var viewModel: TrackerViewModel
    
    @State var herd: DailyHerd
    
    @State var hasExitTimeSelected: Bool
    @State var hasReturnTimeSelected: Bool
    
    @State private var dateInputType: DateInputTime = .exit
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
                                    weatherTypeSelector
                                    exitTimeInput
                                    returnTimeInput
                                    notesInput
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
        .onChange(of: herd.exitTime) { _ in
            hasExitTimeSelected = true
        }
        .onChange(of: herd.returnTime) { _ in
            hasReturnTimeSelected = true
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
            
            Text("Daily Tracker")
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
    
    private var weatherTypeSelector: some View {
        VStack(spacing: 14) {
            Text("Select weather type:")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.oto(with: 20))
                .foregroundStyle(.slBrown)
            
            HStack {
                ForEach(WeatherType.allCases) { type in
                    Button {
                        herd.weatherType = type
                    } label: {
                        VStack(spacing: 0) {
                            Image(type.icon)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 60)
                                .clipped()
                                .background(.slLightBrown)
                                .cornerRadius(20)
                            
                            Text(type.rawValue)
                                .font(.oto(with: 12))
                                .foregroundStyle(herd.weatherType == type ? .white : .slSuperCream)
                        }
                        .padding(.top, 4)
                        .padding(.horizontal, 4)
                        .padding(.bottom, 10)
                        .background(
                            herd.weatherType == type ?
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
    
    private var exitTimeInput: some View {
        Button {
            dateInputType = .exit
            isShowDatePicker.toggle()
        } label: {
            let time = herd.exitTime.formatted(.dateTime.hour().minute())
            Text(hasExitTimeSelected ? time : "Enter time ")
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
    
    private var returnTimeInput: some View {
        Button {
            dateInputType = .returnTime
            isShowDatePicker.toggle()
        } label: {
            let time = herd.returnTime.formatted(.dateTime.hour().minute())
            Text(hasExitTimeSelected ? time : "Enter time ")
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
    
    private var notesInput: some View {
        VStack(spacing: 12) {
            Text("Notes:")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.oto(with: 20))
                .foregroundStyle(.slBrown)
                .multilineTextAlignment(.leading)
            
            CustomTextField(
                text: $herd.notes,
                placeholder: "Enter notes...",
                keyboardType: .default,
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
                
                DatePicker("", selection: dateInputType == .exit ? $herd.exitTime : $herd.returnTime, displayedComponents: [.hourAndMinute])
                    .labelsHidden()
                    .datePickerStyle(.wheel)
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
    AddDailyHerd(
        herd: DailyHerd(isReal: false),
        hasExitTimeSelected: false,
        hasReturnTimeSelected: false
    )
}

#Preview {
    AddDailyHerd(
        herd: DailyHerd(isReal: true),
        hasExitTimeSelected: true,
        hasReturnTimeSelected: true
    )
}

