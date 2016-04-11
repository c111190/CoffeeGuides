//
//  CoffeeGuideAPI.swift
//  CoffeeGuide
//
//  Created by 張嘉恬 on 2016/3/31.
//  Copyright © 2016年 張嘉恬. All rights reserved.
//

import Foundation
import MapKit
import RealmSwift
import QuadratTouch

struct API {
    struct notifications {
        static let venuesUpdated = "venues update"
    }
}
class CoffeeGuideAPI{
    

    static let sharedInstance = CoffeeGuideAPI()
    var session:Session?
    
    init()
    {
        let client = Client(clientID: "Z14QRMQ3F0V5KJJUVRNPZVZTDBPYUPJ0WHKDUZMGTEKP5TKK", clientSecret: "QPTJLAUE3X3LQ35VWHNP42PZYEIF1PS2K31EHQAEXFQXYWTG", redirectURL: "")
        
        let configuration = Configuration(client:client)
        Session.setupSharedSessionWithConfiguration(configuration)
        self.session = Session.sharedSession()
    }
    
    func getCoffeeShopsWithLocation(location:CLLocation)
    {
        if let session = self.session
        {
            var parameters = location.parameters()
            parameters += [Parameter.categoryId: "4bf58dd8d48988d1e0931735"]    //Foursquare 中的類別 ID, coffeeshops 的意思
            parameters += [Parameter.radius: "2000"]
            parameters += [Parameter.limit: "50"]
            
            // 開始搜索，即異步調用 Foursquare，並返回地標數據
            let searchTask = session.venues.search(parameters)
            {
                (result) -> Void in //閉包表達式語法
                
                if let response = result.response
                {
                    if let venues = response["venues"] as? [[String: AnyObject]]
                    {
                        autoreleasepool
                            {
                                let realm = try! Realm()    //try! 關鍵字是 Swift 的異常處理機制。 -> 不處理錯誤
                                realm.beginWrite()
                                
                                for venue:[String: AnyObject] in venues
                                {
                                    let venueObject:Venue = Venue()
                                    
                                    if let id = venue["id"] as? String
                                    {
                                        venueObject.id = id
                                    }
                                    
                                    if let name = venue["name"] as? String
                                    {
                                        venueObject.name = name
                                    }
                                    
                                    if  let location = venue["location"] as? [String: AnyObject]
                                    {
                                        if let longitude = location["lng"] as? Float
                                        {
                                            venueObject.longitude = longitude
                                        }
                                        
                                        if let latitude = location["lat"] as? Float
                                        {
                                            venueObject.latitude = latitude
                                        }
                                        
                                        if let formattedAddress = location["formattedAddress"] as? [String]
                                        {
                                            venueObject.address = formattedAddress.joinWithSeparator(" ")
                                        }
                                    }
                                    
                                    realm.add(venueObject, update: true)
                                }
                                
                                do {
                                    try realm.commitWrite()
                                    print("Committing write...")
                                }
                                catch (let e)
                                {
                                    print("Y U NO REALM ? \(e)")
                                }
                        }
                        
                        NSNotificationCenter.defaultCenter().postNotificationName(API.notifications.venuesUpdated, object: nil, userInfo: nil)
                    }
                }
            }
            
            searchTask.start()
        }
    }
}

extension CLLocation
{
    func parameters() -> Parameters
    {
        let ll      = "\(self.coordinate.latitude),\(self.coordinate.longitude)"
        let llAcc   = "\(self.horizontalAccuracy)"
        let alt     = "\(self.altitude)"
        let altAcc  = "\(self.verticalAccuracy)"
        let parameters = [
            Parameter.ll:ll,
            Parameter.llAcc:llAcc,
            Parameter.alt:alt,
            Parameter.altAcc:altAcc
        ]
        return parameters
    }
}
