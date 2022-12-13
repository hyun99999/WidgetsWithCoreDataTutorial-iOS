//
//  ViewController.swift
//  WidgetsWithCoreDataTutorial-iOS
//
//  Created by kimhyungyu on 2022/11/18.
//

import CoreData
import UIKit

class ViewController: UIViewController {

    // MARK: - Components
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        save(cardNameLabel.text, userName: nameLabel.text, image: backgroundImageView.image ?? UIImage())
        save("두 번째 카드", userName: "두현규", image: UIImage(named: "imgCardWidget") ?? UIImage())
    }
}

// MARK: - Extension
extension ViewController {
    /*
    1. NSManagedObjectContext를 가져온다.
    2. 저장할 Entity 가져온다.
    3. NSManagedObject 생성한다.
     4. NSManagedObjectContext 저장해준다.
     */
    func save(_ cardName: String?, userName: String?, image: UIImage) {
        // AppDelegate 에서 persistentContainer 를 가져와서 entity 생성.
        let viewContext = CoreDataManager.shared.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "CardDetail", in: viewContext)
        
        // NSManagedObject 생성.
        if let entity {
            let card = NSManagedObject(entity: entity, insertInto: viewContext)
            card.setValue(cardName, forKey: "cardName")
            card.setValue(userName, forKey: "userName")
            if let imageData = image.pngData() {
                card.setValue(imageData, forKey: "cardImage")
            }
            
            // NSManagedObjectContext 저장.
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
