import Foundation
import Combine

final class HerdCatalogViewModel: ObservableObject {
    
    private let storageService = DefaultsService.shared
    
    @Published var navPath: [HerdCatalogScreen] = []
    
    @Published private(set) var herds: [Herd] = []
    
    func downloadHerds() {
        Task { [weak self] in
            guard let self else { return }
            
            let herds = await self.storageService.retrieve([Herd].self, for: .herds) ?? []
            
            await MainActor.run {
                self.herds = herds
            }
        }
    }
    
    func save(_ herd: Herd) {
        Task { [weak self] in
            guard let self else { return }
            
            var herds = await self.storageService.retrieve([Herd].self, for: .herds) ?? []
            
            if let index = herds.firstIndex(where: { $0.id == herd.id }) {
                herds[index] = herd
            } else {
                herds.append(herd)
            }
            
            await self.storageService.store(herds, for: .herds)
            
            await MainActor.run {
                self.navPath.removeAll()
            }
        }
    }
    
    func remove(_ herd: Herd) {
        Task { [weak self] in
            guard let self else { return }
            
            var herds = await self.storageService.retrieve([Herd].self, for: .herds) ?? []
            
            if let index = herds.firstIndex(where: { $0.id == herd.id }) {
                herds.remove(at: index)
            }
            
            await self.storageService.store(herds, for: .herds)
            
            self.downloadHerds()
        }
    }
}
