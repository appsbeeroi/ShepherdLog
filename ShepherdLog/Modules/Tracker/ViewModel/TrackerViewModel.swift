import Foundation
import Combine

final class TrackerViewModel: ObservableObject {
    
    private let storageService = DefaultsService.shared
    
    @Published var navPath: [TrackerScreen] = []
    
    @Published private(set) var dailyHerds: [DailyHerd] = []
    
    func downloadHerds() {
        Task { [weak self] in
            guard let self else { return }
            
            let herds = await self.storageService.retrieve([DailyHerd].self, for: .daily) ?? []
            
            await MainActor.run {
                self.dailyHerds = herds
            }
        }
    }
    
    func save(_ herd: DailyHerd) {
        Task { [weak self] in
            guard let self else { return }
            
            var herds = await self.storageService.retrieve([DailyHerd].self, for: .daily) ?? []
            
            if let index = herds.firstIndex(where: { $0.id == herd.id }) {
                herds[index] = herd
            } else {
                herds.append(herd)
            }
            
            await self.storageService.store(herds, for: .daily)
            
            await MainActor.run {
                self.navPath.removeAll()
            }
        }
    }
    
    func remove(_ herd: DailyHerd) {
        Task { [weak self] in
            guard let self else { return }
            
            var herds = await self.storageService.retrieve([DailyHerd].self, for: .daily) ?? []
            
            if let index = herds.firstIndex(where: { $0.id == herd.id }) {
                herds.remove(at: index)
            }
            
            await self.storageService.store(herds, for: .daily)
            
            self.downloadHerds()
        }
    }
}
