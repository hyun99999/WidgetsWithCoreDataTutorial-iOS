//
//  IntentHandler.swift
//  IntentsExtension
//
//  Created by kimhyungyu on 2022/12/02.
//

import Intents
  
class IntentHandler: INExtension, SelectMyCardIntentHandling {
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
}
