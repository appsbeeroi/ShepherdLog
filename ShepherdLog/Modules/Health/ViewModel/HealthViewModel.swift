import Foundation
import Combine

final class HealthViewModel: ObservableObject {
    
    private let storageService = DefaultsService.shared
    
    @Published var navPath: [HealthScreen] = []
    
    @Published private(set) var healthes: [HealthNote] = []
    
    func downloadHealthes() {
        Task { [weak self] in
            guard let self else { return }
            
            let healthes = await self.storageService.retrieve([HealthNote].self, for: .health) ?? []
            
            await MainActor.run {
                self.healthes = healthes
            }
        }
    }
    
    func save(_ health: HealthNote) {
        Task { [weak self] in
            guard let self else { return }
            
            var healthes = await self.storageService.retrieve([HealthNote].self, for: .health) ?? []
            
            if let index = healthes.firstIndex(where: { $0.id == health.id }) {
                healthes[index] = health
            } else {
                healthes.append(health)
            }
            
            await self.storageService.store(healthes, for: .health)
            
            await MainActor.run {
                self.navPath.removeAll()
            }
        }
    }
    
    func remove(_ health: HealthNote) {
        Task { [weak self] in
            guard let self else { return }
            
            var healthes = await self.storageService.retrieve([HealthNote].self, for: .health) ?? []
            
            if let index = healthes.firstIndex(where: { $0.id == health.id }) {
                healthes.remove(at: index)
            }
            
            await self.storageService.store(healthes, for: .health)
            
            self.downloadHealthes()
        }
    }
}
