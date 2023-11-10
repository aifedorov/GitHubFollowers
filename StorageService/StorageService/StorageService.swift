//
//  StorageService.swift
//  StorageService
//
//  Created by Aleksandr Fedorov on 10.11.23.
//

import CoreData

public final class StorageService {
    public static let shared = StorageService()
    public let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "GitHubFollowers")
        persistentContainer.loadPersistentStores(completionHandler: { description, error in
            if let error = error {
                assertionFailure("Core Data store failed to load with error: \(error)")
            }
        })
        
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
}
