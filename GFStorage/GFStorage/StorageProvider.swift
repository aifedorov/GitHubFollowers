import Foundation

public final actor StorageProvider<Entity: Equatable & Codable & Identifiable & Sendable> {
    private let fileStorageService: FileStorageService<Entity>
    
    public init(_ fileStorageService: FileStorageService<Entity>) {
        self.fileStorageService = fileStorageService
    }
    
    public func save(_ entities: [Entity]) async throws {
        try await fileStorageService.save(entities)
    }
    
    public func delete(_ entities: [Entity]) async throws {
        try await fileStorageService.delete(entities)
    }
    
    public func load() async throws -> [Entity] {
        try await fileStorageService.load()
    }
    
    public func contains(_ entity: Entity) async -> Bool {
        return await fileStorageService.savedEntities.contains { $0 == entity }
    }
}
