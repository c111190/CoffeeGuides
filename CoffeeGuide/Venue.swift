//
//  Venue.swift
//  CoffeeGuide
//
//  Created by 張嘉恬 on 2016/3/31.
//  Copyright © 2016年 張嘉恬. All rights reserved.
//

import Foundation
import RealmSwift
import MapKit

class Venue: Object
{
    dynamic var id:String = ""
    dynamic var name:String = ""
    dynamic var latitude:Float = 0
    dynamic var longitude:Float = 0
    dynamic var address:String = ""
    
 
    var coordinate:CLLocation {
        return CLLocation(latitude: Double(latitude), longitude: Double(longitude));
    }
    
    override static func primaryKey() -> String? //將primarykey(主鍵)改為id
    {
        return "id";
    }
}
