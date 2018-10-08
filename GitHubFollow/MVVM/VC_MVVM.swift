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

class VC_MVVM: UIViewController {

    var realView : FollowView = FollowView.createInstance()

    var disposeBag : DisposeBag = DisposeBag()
    
    var refreshStream : ControlEvent<Void> {
        get{
            return realView.refreshBtn.rx.tap
        }
    }
    
    var close1ClickStream : ControlEvent<Void> {
        get{
            return realView.delA.rx.tap
        }
    }
    
    var close2ClickStream : ControlEvent<Void> {
        get{
            return realView.delB.rx.tap
        }
    }

    var close3ClickStream : ControlEvent<Void> {
        get{
            return realView.delC.rx.tap
        }
    }

    
    override func loadView() {
        self.view = realView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    func config() {
        
        let viewModel = GitHubViewModel(
            input : (
                refreshTap : refreshStream.asObservable(),
                close1Tap : close1ClickStream.asObservable(),
                close2Tap : close2ClickStream.asObservable(),
                close3Tap : close3ClickStream.asObservable()
            ),
            depends : API()
        )
        
        
        viewModel.suggest1.observeOn(MainScheduler.instance)
            .subscribe( onNext : {[weak realView] person in
                realView?.renderSuggestion(person, 0);
            }).disposed(by: disposeBag)
        
        viewModel.suggest2.observeOn(MainScheduler.instance)
            .subscribe( onNext : {[weak realView] person in
                realView?.renderSuggestion(person, 1);
            }).disposed(by: disposeBag)
        
        viewModel.suggest3.observeOn(MainScheduler.instance)
            .subscribe( onNext : {[weak realView] person in
                realView?.renderSuggestion(person, 2);
            }).disposed(by: disposeBag)
    }
}
