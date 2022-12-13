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
        
        saveContext()
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
    func saveContext() {
        // AppDelegate 에서 persistentContainer 를 가져와서 entity 생성.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let viewContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "CardDetail", in: viewContext)
        
        // NSManagedObject 생성.
        if let entity {
            let card = NSManagedObject(entity: entity, insertInto: viewContext)
            card.setValue(cardNameLabel.text, forKey: "cardName")
            card.setValue(nameLabel.text, forKey: "userName")
            if let image = backgroundImageView.image?.pngData() {
                card.setValue(image, forKey: "cardImage")
            }
            
            // NSManagedObjectContext 저장.
            do {
                try viewContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
