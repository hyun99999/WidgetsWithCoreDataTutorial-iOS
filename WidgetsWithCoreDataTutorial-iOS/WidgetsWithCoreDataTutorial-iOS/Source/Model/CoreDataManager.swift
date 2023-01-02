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
        
        // ✅ App Group identifier 와 연결된 container directory 를 반환. 즉, 해당 group 의 공유 directory 의 파일 시스템 내 위치를 지정하는 NSURL 인스턴스를 반환.
        guard let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else { fatalError("Shared file container could not be created.") }
        
        let storeURL = url.appending(path: "WidgetsWithCoreDataTutorial_iOS.sqlite")
        
        // ✅ persistent store 를 생성 및 로드하는데 사용되는 description object.
        let storeDescription = NSPersistentStoreDescription(url: storeURL)

        let container = NSPersistentContainer(name: "WidgetsWithCoreDataTutorial_iOS")
        
        // ✅ 생성된 container 에서 사용하는 persistent store 의 타입을 재정의하려면 NSPersistentStoreDescription 배열로 설정할 수 있다.
        container.persistentStoreDescriptions = [storeDescription]
        
        // ✅ container 가 persistent store 를 로드하고, CoreData stack 을 생성 완료하도록 지시한다.
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
