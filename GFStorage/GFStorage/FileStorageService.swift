import Foundation
import os

public actor FileStorageService<Entity: Equatable & Codable & Identifiable> {
    public private(set) var savedEntities: [Entity] = []
    private let logger = Logger(subsystem: "ru.aifedorov.GitHubFollowers.GFStorage.FileStorageService", category: "FileStorageIO")
    
    public init() {}
    
    func save(_ entities: [Entity]) throws {
        if savedEntities == entities {
            logger.debug("The data hasn't changed. No need to save.")
            return
        }
        
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .binary
        
        let data: Data
        do {
            data = try encoder.encode(entities)
            
        } catch let error as EncodingError {
            logger.error("An error occurred while encoding the data: \(error.localizedDescription)")
            throw StorageError.encodingError(error)
            
        } catch {
            logger.error("*** An unexpected error occurred while encoding the data: \(error.localizedDescription) ***")
            throw StorageError.unknown(error)
        }
        
        do {
            try data.write(to: self.dataURL, options: [.atomic])
            savedEntities = entities
            self.logger.debug("Data saved on the disk.")
            
        } catch {
            self.logger.error("An error occurred while saving the data: \(error.localizedDescription)")
            throw StorageError.unknown(error)
        }
    }
    
    func delete(_ entities: [Entity]) throws {
        guard !entities.isEmpty else {
            logger.debug("Input data is empty. It can't delete anything.")
            return
        }
        
        var updatedCache = savedEntities
        updatedCache.removeAll { savedEntity in
            entities.contains { $0 == savedEntity }
        }
        
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .binary
        
        let data: Data
        do {
            data = try encoder.encode(updatedCache)
            
        } catch let error as EncodingError {
            logger.error("An error occurred while encoding the data: \(error.localizedDescription)")
            throw StorageError.encodingError(error)
            
        } catch {
            logger.error("*** An unexpected error occurred while encoding the data: \(error.localizedDescription) ***")
            throw StorageError.unknown(error)
        }
        
        do {
            try data.write(to: dataURL, options: [.atomic])
            savedEntities = updatedCache
            self.logger.debug("Data saved on the disk.")
            
        } catch {
            self.logger.error("An error occurred while saving the data: \(error.localizedDescription)")
            throw StorageError.unknown(error)
        }
    }
    
    func load() throws -> [Entity] {
        logger.debug("Loading the data from file.")
        
        let path = try dataURL.absoluteString
        if !FileManager.default.fileExists(atPath: path) {
            logger.debug("The file: \(path) doesn't exist.")
            FileManager.default.createFile(atPath: path, contents: nil)
        }
        
        let entities: [Entity]
        do {
            let data = try Data(contentsOf: dataURL)
            let decoder = PropertyListDecoder()
            
            entities = try decoder.decode([Entity].self, from: data)
            logger.debug("Data loaded from disk.")
            
        } catch CocoaError.fileReadNoSuchFile {
            entities = []
            logger.debug("No file found--created an empty array.")
            
        } catch {
            logger.error("*** An unexpected error occurred while loading the data from file: \(error.localizedDescription) ***")
            throw StorageError.unknown(error)
        }
        
        savedEntities = entities
        return entities
    }
    
    private var dataURL: URL {
        get throws {
            try FileManager
                   .default
                   .url(for: .documentDirectory,
                        in: .userDomainMask,
                        appropriateFor: nil,
                        create: false)
                   .appendingPathComponent("GitHubFollowers.plist")
        }
    }
}
