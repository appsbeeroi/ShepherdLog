enum OnboardingPage: Identifiable {
    case page1
    case page2
    
    var id: Self {
        self
    }
    
    var title: String {
        switch self {
            case .page1:
                "Manage your\nherds with ease!"
            case .page2:
                "Track every day\nin the field!"
        }
    }
    
    var message: String {
        switch self {
            case .page1:
                "Add and edit herd cards, record the number of animals, and specify their types sheep, goats, cows, and more. Everything you need to keep your farm organized is in one place."
            case .page2:
                "Mark the time when your herd goes out and returns, add weather notes, and log special events. Never lose track of your animals’ daily routine again!"
        }
    }
    
    var icon: ImageResource {
        switch self {
            case .page1:
                    .Images.kozelPanel
            case .page2:
                    .Images.sheepPanel
        }
    }
}
