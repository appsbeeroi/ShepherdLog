import SwiftUI

struct HerdCellView: View {
    
    let herd: Herd
    let action: () -> Void
    let removeAction: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                if let icon = herd.type?.icon {
                    Image(icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 90, height: 90)
                }
                
                VStack(spacing: 7) {
                    Text("Herd")
                        .font(.oto(with: 20))
                        .foregroundStyle(.slSuperCream)
                    
                    Text("Sheep: \(herd.number)")
                        .font(.oto(with: 10))
                        .foregroundStyle(.slSuperCream)
                    
                    HStack(spacing: 8) {
                        Image(.Images.Buttons.edit)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        
                        Button {
                            removeAction()
                        } label: {
                            Image(.Images.Buttons.delete)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                        }
                    }
                }
            }
            .frame(height: 100)
            .frame(width: (UIScreen.main.bounds.width - 32 - 4 - 38) / 2)
            .padding(.trailing)
            .background(.slLightBrown)
            .cornerRadius(24)
            .overlay {
                RoundedRectangle(cornerRadius: 24)
                    .stroke(.slBrown, lineWidth: 4)
            }
        }
    }
}
