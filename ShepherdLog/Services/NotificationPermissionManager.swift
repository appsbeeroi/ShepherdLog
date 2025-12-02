import UserNotifications

enum NotificationPermission {
    case allowed
    case denied
    case undetermined
}

final class NotificationPermissionManager {
    
    static let shared = NotificationPermissionManager()
    
    private init() {}
    
    var currentStatus: NotificationPermission {
        get async {
            let settings = await UNUserNotificationCenter.current().notificationSettings()
            
            switch settings.authorizationStatus {
            case .authorized, .provisional:
                return .allowed
            case .denied:
                return .denied
            case .notDetermined:
                return .undetermined
            default:
                return .denied
            }
        }
    }
    
    @discardableResult
    func requestAuthorization() async -> Bool {
        do {
            let granted = try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .badge, .sound])
            return granted
        } catch {
            print("⚠️ Failed to request push permission:", error.localizedDescription)
            return false
        }
    }
}
