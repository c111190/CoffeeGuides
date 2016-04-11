//
//  CoffeeGuideAnnotation.swift .swift
//  CoffeeGuide
//
//  Created by 張嘉恬 on 2016/3/31.
//  Copyright © 2016年 張嘉恬. All rights reserved.
//

import Foundation
import MapKit

class CoffeeAnnotation:NSObject, MKAnnotation{
    let title:String?
    let subtitle:String?
    let coordinate:CLLocationCoordinate2D
    
    init(title:String?, subtitle:String?, coordinate:CLLocationCoordinate2D)
    {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        
        super.init()
        
    }
    
}