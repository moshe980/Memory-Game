//
//  User.swift
//  Memory Game
//
//  Created by user196685 on 5/15/21.
//

import Foundation

class User:Codable{
    var name:String
    var score:Double
    var lat:Double
    var lon:Double
    
    
    init(name:String,score:Double,lat:Double,lon:Double) {
        self.name=name
        self.score=score
        self.lat=lat
        self.lon=lon
    }
    
    
    func getName()->String{
        return self.name
    }
    func getScore()->Double{
        return self.score
    }
    func getLat()->Double{
        return self.lat
    }
    func getLon()->Double{
        return  self.lon
    }
}
