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



class VC_MVC: UIViewController {
    
    let realView : FollowView = FollowView.createInstance()
    
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
        
        let requestStream = refreshStream.startWith(())
            .map{_ -> String in
                let randomOffset : Int = Int(arc4random_uniform(10000) % 500)
                return "https://api.github.com/users?since=" + "\(randomOffset)"
        }
        
        
        let responseStream = requestStream
            .flatMap{ requestUrl -> Observable<[Person]> in
                return API().urlStream(urlString: requestUrl)
            }.share()
        
        
        let suggestion1Stream = createSuggestionStream(close1ClickStream, refreshStream, responseStream);
        let suggestion2Stream = createSuggestionStream(close2ClickStream, refreshStream, responseStream);
        let suggestion3Stream = createSuggestionStream(close3ClickStream, refreshStream, responseStream);
        
        
        suggestion1Stream.observeOn(MainScheduler.instance)
            .subscribe( onNext : {[weak realView] person in
                realView?.renderSuggestion(person, 0);
            }).disposed(by: disposeBag)
        
        suggestion2Stream.observeOn(MainScheduler.instance)
            .subscribe( onNext : {[weak realView] person in
                realView?.renderSuggestion(person, 1);
            }).disposed(by: disposeBag)
        
        suggestion3Stream.observeOn(MainScheduler.instance)
            .subscribe( onNext : {[weak realView] person in
                realView?.renderSuggestion(person, 2);
            }).disposed(by: disposeBag)
        
    }
    
    
    func createSuggestionStream(_ closeTap:  ControlEvent<Void> ,
                                _ refreshTap :  ControlEvent<Void> ,
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
}

