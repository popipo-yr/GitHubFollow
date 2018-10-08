//
//  API.swift
//  GitHubFollow
//
//  Created by RuiYang on 2018/8/15.
//  Copyright © 2018年 CreditHome. All rights reserved.
//

import Foundation
import RxSwift

class API{
    
    func urlStream(urlString : String) -> Observable<[Person]> {
        
        let kk = Observable<[Person]>.create{ (observer) -> Disposable in
            
            let url = URL(string: urlString)
            var request = URLRequest(url: url!)   //请求
            request.httpMethod = "POST"   //修改http方法
            
            let session = URLSession.shared
            
            //初始化请求
            let dataTask = session.dataTask(with: request,
                                            completionHandler: { (data, resp, err) in
                                                
                                                repeat{
                                                    
                                                    if err != nil {
                                                        observer.onError(err!)
                                                        break;
                                                    }
                                                    
                                                    guard let response = resp as? HTTPURLResponse else {
                                                        break;
                                                    }
                                                    
                                                    var person_cache : [Person]  = []
                                                    
                                                    for _ in 0 ..< 10
                                                    {
                                                        let randomOffset : Int = Int(arc4random_uniform(10000) % 500)
                                                        
                                                        let s  = Person()
                                                        s.name = "\(randomOffset)"
                                                        person_cache.append(s)
                                                    }
                                                    
                                                    
                                                    
                                                    if response.statusCode != 200 {
                                                        
                                                        observer.onNext(person_cache);
                                                        break;
                                                    }
                                                    
                                                    observer.onNext(person_cache);
                                                    
                                                }while(false)
                                                
                                                observer.onCompleted()
            }
                ) as URLSessionTask
            
            dataTask.resume()   //执行任务
            
            return Disposables.create {
                print(dataTask.state)
            }
            
        }
        
        return kk
    }
}
