//
//  View.swift
//  GitHubFollow
//
//  Created by RuiYang on 2018/8/23.
//  Copyright © 2018年 CreditHome. All rights reserved.
//

import UIKit

class FollowView: UIView {

    @IBOutlet weak var refreshBtn: UIButton!
    
    @IBOutlet weak var imageA: UIImageView!
    @IBOutlet weak var imageB: UIImageView!
    @IBOutlet weak var imageC: UIImageView!
    
    @IBOutlet weak var delA: UIButton!
    @IBOutlet weak var delB: UIButton!
    @IBOutlet weak var delC: UIButton!
    
    @IBOutlet weak var nameA: UIButton!
    @IBOutlet weak var nameB: UIButton!
    @IBOutlet weak var nameC: UIButton!
    
    class func createInstance() -> FollowView {
        let view = Bundle.main.loadNibNamed("View", owner: nil, options: nil)!.first
        return view as! FollowView
    }
    
    // Rendering ---------------------------------------------------
    func renderSuggestion(_ person : Person?, _ index : Int) {
        
        guard index < 3  && index >= 0 else { return }
        
        let photos = [imageA, imageB, imageC]
        let names = [nameA, nameB, nameC]
        
        let cPhoto : UIImageView! = photos[index]
        let cName :  UIButton! = names[index]
        
        guard let person = person else {
            cPhoto.isHidden = true
            cName.isHidden = true
            
            cName.setTitle("change", for: UIControlState.normal)
            
            return;
        }
        
        
        cPhoto.image = nil;
        cName.setTitle(person.name, for: UIControlState.normal)
        
        cPhoto.isHidden = false
        cName.isHidden = false
    }
}
