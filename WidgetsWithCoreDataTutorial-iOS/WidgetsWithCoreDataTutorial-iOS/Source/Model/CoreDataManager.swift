//
//  CoreDataManager.swift
//  WidgetsWithCoreDataTutorial-iOS
//
//  Created by kimhyungyu on 2022/12/13.
//

import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() { }
    
    // ✅ AppGroup 을 활용하여 CoreData 로 저장한 데이터를 공유.
    private let appGroup = "group.WidgetsWithCoreDataTutorial-iOS"
    
    lazy var persistentContainer: NSPersistentContainer = {
        // ✅
        guard let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else { fatalError("Shared file container could not be created.") }
        let storeURL = url.appending(path: "WidgetsWithCoreDataTutorial_iOS.sqlite")
        let storeDescription = NSPersistentStoreDescription(url: storeURL)
        
        let container = NSPersistentContainer(name: "WidgetsWithCoreDataTutorial_iOS")
        
        // ✅
        container.persistentStoreDescriptions = [storeDescription]
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}

// MARK: - extensions

extension CoreDataManager {
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetch(entityName: String) -> [NSManagedObject] {
        let viewContext = persistentContainer.viewContext
        let fetchReqeust = NSFetchRequest<NSManagedObject>(entityName: entityName)
        
        do {
            let fetchResult = try viewContext.fetch(fetchReqeust)
            
            return fetchResult
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
