//
//  IntentHandler.swift
//  IntentsExtension
//
//  Created by kimhyungyu on 2022/12/02.
//

import Intents
  
class IntentHandler: INExtension {
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
}

extension IntentHandler: SelectMyCardIntentHandling {
    func provideMyCardOptionsCollection(for intent: SelectMyCardIntent, with completion: @escaping (INObjectCollection<Card>?, Error?) -> Void) {
        // ✅ CoreData 조회.
        let cardDetail = CoreDataManager.shared.fetch(entityName: "CardDetail")
//        let myCards: [Card] = MyCardDetail.availableMyCards.map { card in
        let myCards: [Card] = cardDetail.map { card in
            let cardName = card.value(forKey: "cardName") as? String ?? ""
            let myCard = Card(identifier: cardName, display: cardName)
            
            myCard.cardName = cardName
            return myCard
        }
        
        // ✅ Create a collection with the array of characters.
        let collection = INObjectCollection(items: myCards)
        
        // ✅ Call the completion handler, passing the collection.
        completion(collection, nil)
    }
    
    func defaultMyCard(for intent: SelectMyCardIntent) -> Card? {
//        let defaultCard = MyCardDetail.availableMyCards[0]
        let cardDetail = CoreDataManager.shared.fetch(entityName: "CardDetail")
        let defaultCardName = cardDetail[0].value(forKey: "cardName") as? String ?? ""
        
        let card = Card(identifier: defaultCardName, display: defaultCardName)
        card.cardName = defaultCardName
        
        return card
    }
}
