//
//  ViewController.swift
//  GitHubFollow
//
//  Created by RuiYang on 2018/8/10.
//  Copyright © 2018年 CreditHome. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class VC_RD: UIViewController {

    let realView : FollowView = FollowView.createInstance()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = realView
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        struct _State {
            static var empty: _State {
                return _State(persons: [], newItem: (-1, Person()), isGetNew: false)
            }
            
            var persons : [Person]
            var newItem : (Int, Person)
            var isGetNew : Bool
        }
        
        enum _Mutation {
            case getNew
            case refreshAll([Person])
            case refreshItem(Int)
        }
        
        func reduce(state: _State, mutation: _Mutation) -> _State {
            switch mutation {
            
            case .getNew:
                var result = state
                result.isGetNew = true
                return result
                
            case .refreshAll(let persons):
                var result = state
                result.persons = persons
                result.isGetNew = false
                return result
                
            case .refreshItem(let itemIndex):
                var result = state
                let persons = result.persons
                guard persons.count > 0 else { return  result}
                let index = Int(arc4random_uniform(10000) %  UInt32(persons.count))
                result.newItem = (itemIndex, persons[index])
                return result
            }
        }
        
        Observable.system(
            initialState: _State.empty,
            reduce: reduce,
            scheduler: MainScheduler.instance,
            scheduledFeedback:
            [
                bind(self) { me, state -> Bindings<_Mutation> in
                    
                    let subscriptions = [
                        state.map{ $0.newItem }
                            .subscribe(onNext : { index, person in
                                me.realView.renderSuggestion(person, index)
                            })
                    ]
                    
                    let mutations = [
                        
                        me.realView.refreshBtn.rx.tap.map{ _Mutation.getNew },
                        me.realView.delA.rx.tap.map { _Mutation.refreshItem(0) },
                        me.realView.delB.rx.tap.map { _Mutation.refreshItem(1) },
                        me.realView.delC.rx.tap.map { _Mutation.refreshItem(2) },
                        ]
                    
                    return Bindings(subscriptions: subscriptions,
                                    mutations: mutations)
                },
                
                react(query: { $0.persons }, effects: { persons -> Observable<_Mutation> in
                    guard persons.count > 0 else { return Observable.empty() }
                    return Observable.of(_Mutation.refreshItem(0),
                                         _Mutation.refreshItem(1),
                                         _Mutation.refreshItem(2))
                }),
                
                react(query: { $0.isGetNew }, effects: { isGetNew -> Observable<_Mutation> in
                    
                    guard isGetNew else { return  Observable.empty()}
                    
                    let randomOffset : Int = Int(arc4random_uniform(10000) % 500)
                    let requestUrl = "https://api.github.com/users?since=" + "\(randomOffset)"
                    return API().urlStream(urlString: requestUrl).map({ persons in
                        _Mutation.refreshAll(persons)
                    })
                })
            ]
            )
            .subscribe()
            .disposed(by: disposeBag)

        
    }
}


