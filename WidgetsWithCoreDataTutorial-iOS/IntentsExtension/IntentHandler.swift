//
//  IntentHandler.swift
//  IntentsExtension
//
//  Created by kimhyungyu on 2022/12/02.
//

import Intents
  
class IntentHandler: INExtension, SelectMyCardIntentHandling {
    func provideMyCardOptionsCollection(for intent: SelectMyCardIntent, with completion: @escaping (INObjectCollection<Card>?, Error?) -> Void) {
        let myCards: [Card] = MyCardDetail.availableMyCards.map { card in
            let myCard = Card(identifier: card.cardName, display: card.cardName)
            myCard.cardName = card.cardName
            return myCard
        }
        
        // ✅ Create a collection with the array of characters.
        let collection = INObjectCollection(items: myCards)
        
        // ✅ Call the completion handler, passing the collection.
        completion(collection, nil)
    }
    
    func defaultMyCard(for intent: SelectMyCardIntent) -> Card? {
        let defaultCard = MyCardDetail.availableMyCards[0]
        let card = Card(identifier: defaultCard.cardName, display: defaultCard.cardName)
        card.cardName = defaultCard.cardName
        
        return card
    }
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
}
