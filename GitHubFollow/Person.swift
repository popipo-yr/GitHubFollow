//
//  Person.swift
//  GitHubFollow
//
//  Created by RuiYang on 2018/8/23.
//  Copyright © 2018年 CreditHome. All rights reserved.
//

class Person : Equatable {
    var name : String = ""
}

func ==(lhs: Person, rhs: Person) -> Bool{
    return lhs === rhs
}
