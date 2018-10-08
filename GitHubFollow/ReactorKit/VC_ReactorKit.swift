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


class VC_ReactorKit: UIViewController, StoryboardView {

    var realView : FollowView = FollowView.createInstance()
    var disposeBag = DisposeBag()
    
//    var reactor = FollowReactor()
    
    override func loadView() {
        self.view = realView
        self.reactor = FollowReactor()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func bind(reactor: FollowReactor) {
        //Action
        
        realView.refreshBtn.rx.tap
            .map { Reactor.Action.loadItems }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        realView.delA.rx.tap
            .map { Reactor.Action.refreshItem(0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        realView.delB.rx.tap
            .map { Reactor.Action.refreshItem(1) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        realView.delC.rx.tap
            .map { Reactor.Action.refreshItem(2) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        // State
        reactor.state.filter { state in
            return state.newItme != nil
            }
            .map { state -> (Int, Person) in
                return state.newItme!
            }
            .subscribe(onNext : { [weak realView] index, person in
                guard let realView = realView else { return }
                realView.renderSuggestion(person, index)
            })
            .disposed(by: disposeBag)
        

        reactor.state.map{ state -> [Person] in
            return state.persons
            }
            .distinctUntilChanged()
            .filter{
                return $0.count > 0
            }
            .subscribe(onNext : { [weak  realView] _ in

                realView?.delA.sendActions(for: UIControlEvents.touchUpInside)
                realView?.delB.sendActions(for: UIControlEvents.touchUpInside)
                realView?.delC.sendActions(for: UIControlEvents.touchUpInside)
            })
            .disposed(by: disposeBag)
    }

}
