//
//  ViewModel.swift
//  GitHubFollow
//
//  Created by RuiYang on 2018/8/14.
//  Copyright © 2018年 CreditHome. All rights reserved.
//

import Foundation
import RxSwift

class GitHubViewModel{
    
    var suggest1 : Observable<Person?>
    var suggest2 : Observable<Person?>
    var suggest3 : Observable<Person?>
    
    init(input:(
        refreshTap : Observable<Void>,
        close1Tap : Observable<Void>,
        close2Tap : Observable<Void>,
        close3Tap : Observable<Void>
        ),
         depends: API
        
        ) {
        
        let response = input.refreshTap.startWith(())
            .map{_ -> String in
                let randomOffset : Int = Int(arc4random_uniform(10000) % 500)
                return "https://api.github.com/users?since=" + "\(randomOffset)"
            }.flatMap{ requestUrl -> Observable<[Person]> in
                return depends.urlStream(urlString: requestUrl)
            }.share()

        
        func createSuggestionStream(_ closeTap: Observable<Void>,
                                    _ refreshTap : Observable<Void>,
                                    _ persons : Observable<[Person]> ) -> Observable<Person?> {
            
            let a =  Observable<Person?>.combineLatest(closeTap.startWith(()), persons){_, persons in
                
                let index = Int(arc4random_uniform(10000) %  UInt32(persons.count))
                return persons[index]
            }
            
            let aa  = refreshTap.map{_ -> Person? in
                return nil
            }
            
            let b = Observable.of(a, aa).merge()
            
            return b.startWith(nil)
        }

        suggest1 = createSuggestionStream(input.close1Tap, input.refreshTap, response);
        suggest2 = createSuggestionStream(input.close2Tap, input.refreshTap, response);
        suggest3 = createSuggestionStream(input.close3Tap, input.refreshTap, response);
    }
    

}
