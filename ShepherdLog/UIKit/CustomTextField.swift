import SwiftUI

struct CustomTextField: View {
    
    @Binding var text: String
    
    let placeholder: String
    let keyboardType: UIKeyboardType
    
    @FocusState.Binding var focused: Bool
    
    var body: some View {
        HStack {
            TextField("", text: $text, prompt: Text(placeholder)
                .font(.oto(with: 20))
                .foregroundColor(.slSuperCream.opacity(0.5))
            )
            .font(.oto(with: 20))
            .foregroundColor(.slSuperCream)
            .keyboardType(keyboardType)
            .focused($focused)
            
            if text != "" {
                Button {
                    text = ""
                    focused = false
                } label: {
                    Image(systemName: "multiply.circle.fill")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(.slSuperCream.opacity(0.5))
                }
            }
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
