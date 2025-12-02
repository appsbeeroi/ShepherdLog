import SwiftUI

struct OnboardingView: View {
    
    @AppStorage("hasOnboardingCompleted") var hasOnboardingCompleted = false
    
    @State private var currentPage: OnboardingPage = .page1
    
    var body: some View {
        ZStack {
            Image(.Images.onboarding)
                .resizeImage()
            
            VStack(spacing: 30) {
                Image(currentPage.icon)
                    .resizable()
                    .scaledToFit()
                    .offset(x: 20)
                    .overlay {
                        VStack(spacing: 30) {
                            Text(currentPage.title)
                                .font(.oto(with: 22))
                            
                            Text(currentPage.message)
                                .font(.oto(with: 18))
                        }
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.leading)
                        .padding(50)
                        .offset(y: 60)
                    }
                
                
                Button {
                    switch currentPage {
                        case .page1:
                            currentPage = .page2
                        case .page2:
                            withAnimation {
                                hasOnboardingCompleted = true
                            }
                    }
                } label: {
                    Image(.Images.buttonBG)
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal, 12)
                        .overlay {
                            Text("Next")
                                .font(.oto(with: 22))
                                .foregroundStyle(.black)
                                .offset(y: -5)
                        }
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
    }
}

#Preview {
    OnboardingView()
}
