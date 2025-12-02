import SwiftUI

struct ContentView: View {
    
    @AppStorage("hasOnboardingCompleted") var hasOnboardingCompleted = false
    
    @State private var isLaunched = false
    
    var body: some View {
        if isLaunched {
            if hasOnboardingCompleted {
                MainView()
                    .transition(.opacity)
            } else {
                OnboardingView()
                    .transition(.opacity)
            }
        } else {
            SplashScreen(isLaunched: $isLaunched)
        }
    }
}

#Preview {
    ContentView()
}
