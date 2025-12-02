import SwiftUI

struct SplashScreen: View {
    
    @Binding var isLaunched: Bool
    
    @State private var isStartAnimating = false
    
    var body: some View {
        ZStack {
            Image(.Images.splashBackground)
                .resizeImage()
            
            VStack {
                Image(.Images.splashNameApp)
                    .resizable()
                    .scaledToFit()
                    .padding(50)
                    .scaleEffect(isStartAnimating ? 0.8 : 1)
                    .animation(.smooth.repeatForever(), value: isStartAnimating)
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isStartAnimating = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        isLaunched = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashScreen(isLaunched: .constant(false))
}
