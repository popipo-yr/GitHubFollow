//
//  FollowReactor.swift
//  GitHubFollow
//
//  Created by RuiYang on 2018/8/24.
//  Copyright © 2018年 CreditHome. All rights reserved.
//

import RxSwift
import Foundation

class FollowReactor: Reactor {
    
    enum Action {
        case loadItems
        case refreshItem(Int)
    }
    
    enum Mutation {
        case setPersons([Person])
        case setPerson(Person?, Int)
        case err
    }
    
    struct State {
        var persons: [Person] = []
        var newItme : (Int , Person)?
    }
    
    
    let initialState = State()


    func mutate(action: FollowReactor.Action) -> Observable<FollowReactor.Mutation> {
        switch action {
        case .loadItems:
            let randomOffset : Int = Int(arc4random_uniform(10000) % 500)
            let requestUrl = "https://api.github.com/users?since=" + "\(randomOffset)"
            return  API().urlStream(urlString: requestUrl).map{
                        Mutation.setPersons($0)
            }

        case let .refreshItem(indexItem):
            let persons = self.currentState.persons
            guard persons.count > 0 else { return  Observable.of(Mutation.err)}
            let index = Int(arc4random_uniform(10000) %  UInt32(persons.count))
            return Observable.of(Mutation.setPerson(persons[index], indexItem))
        }
    }
    
    func reduce(state: FollowReactor.State, mutation: FollowReactor.Mutation) -> FollowReactor.State {
        switch mutation {
        case let .setPersons(persons):
            var newState = state
            newState.persons = persons
            return newState
            
        case let .setPerson(person, index):
            var newState = state
            newState.newItme = (index, person) as? (Int, Person)
            return newState
        case .err:
            return state
        }
    }
}


