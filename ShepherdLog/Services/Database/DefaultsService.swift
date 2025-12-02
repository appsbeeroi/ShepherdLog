import Foundation

enum UDKeys: String {
    case herds
    case daily
    case health
}

final class DefaultsService {
    
    static let shared = DefaultsService()
    
    private let defaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    func store<T: Codable>(_ value: T, for key: UDKeys) async {
        do {
            let data = try encoder.encode(value)
            defaults.set(data, forKey: key.rawValue)
        } catch {
            debugPrint("⚠️ Failed to encode \(T.self): \(error.localizedDescription)")
        }
    }
    
    func retrieve<T: Codable>(_ type: T.Type, for key: UDKeys) async -> T? {
        guard let data = defaults.data(forKey: key.rawValue) else {
            return nil
        }
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            debugPrint("⚠️ Failed to decode \(T.self): \(error.localizedDescription)")
            return nil
        }
    }
    
    func clear(for key: UDKeys) {
        defaults.removeObject(forKey: key.rawValue)
    }
}
