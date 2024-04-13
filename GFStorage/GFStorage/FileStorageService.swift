import Foundation
import os

public actor FileStorageService<Entity: Equatable & Codable & Identifiable> {
    public private(set) var savedEntities: [Entity] = []
    private let logger = Logger(
        subsystem: "ru.aifedorov.GitHubFollowers.GFStorage.FileStorageService",
        category: "FileStorageIO"
    )
    private lazy var dataURL: URL? = {
        do {
            return try FileManager
                .default
                .url(
                    for: .documentDirectory,
                    in: .userDomainMask,
                    appropriateFor: nil,
                    create: false
                )
                .appendingPathComponent(
                    "GitHubFollowers.plist"
                )
        } catch {
            return nil
        }
    }()
    
    public init() {}
    
    func save(_ entities: [Entity]) throws {
        guard savedEntities != entities else {
            logger.debug("The data hasn't changed. No need to save.")
            return
        }
        
        savedEntities.append(contentsOf: entities)
        savedEntities = try writeToFile(savedEntities)
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
        
        savedEntities = try writeToFile(updatedCache)
    }
    
    func load() throws -> [Entity] {
        logger.debug("Loading the data from file.")
        savedEntities = try readFromFile()
        return savedEntities
    }
    
    private func writeToFile(_ entities: [Entity]) throws -> [Entity] {
        guard let dataURL else {
            throw StorageError.unknown(nil)
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
            try data.write(to: dataURL, options: [.atomic])
            self.logger.debug("Data saved on the disk.")
            return entities
        } catch {
            self.logger.error("An error occurred while saving the data: \(error.localizedDescription)")
            throw StorageError.unknown(error)
        }
    }
    
    private func readFromFile() throws -> [Entity] {
        guard let dataURL else {
            throw StorageError.unknown(nil)
        }
        
        let path = dataURL.path
        if !FileManager.default.fileExists(atPath: path) {
            FileManager.default.createFile(atPath: path, contents: nil)
            logger.debug("The file: \(path) doesn't exist--created new file.")
        }
        
        let entities: [Entity]
        do {
            let data = try Data(contentsOf: dataURL)
            let decoder = PropertyListDecoder()
            
            entities = try decoder.decode([Entity].self, from: data)
            logger.debug("Data loaded from disk.")
            
        } catch CocoaError.fileReadNoSuchFile {
            entities = []
            logger.debug("No file found--created an empty array in memory.")
            
        } catch {
            logger.error("*** An unexpected error occurred while loading the data from file: \(error.localizedDescription) ***")
            throw StorageError.unknown(error)
        }
        
        return entities
    }
}
