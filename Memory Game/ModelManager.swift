//
//  ModelManager.swift
//  Memory Game
//
//  Created by user196685 on 5/15/21.
//

import Foundation

class ModelManager{
    static let instance=ModelManager()
    private let preferences:UserDefaults
    private let currentRecordKey:String
    private let encoder:JSONEncoder
    private let decoder:JSONDecoder
    private var dataCounter:Int

    private init(){
        self.preferences = UserDefaults.standard
        self.currentRecordKey = "currentRecord"
        self.encoder = JSONEncoder()
        self.decoder = JSONDecoder()
        dataCounter=0
    }
    func size()->Int{
        if let data = UserDefaults.standard.data(forKey: currentRecordKey) {
            do {
                let users = try decoder.decode(Array<User>.self, from: data)
                return users.count

            } catch {
                print("Unable to Decode User: (\(error))")
            }
        }
        return 0
        
    }
    func saveUser(user:User){
        var users=[User]()
        users=self.loadusers() ?? [User]()
        users.append(user)
        users=users.sorted(by: { $0.getScore() < $1.getScore() })
        if users.count>10{
            users.remove(at: 10)
        }

        do {
            let data=try encoder.encode(users)
            preferences.setValue(data, forKeyPath: currentRecordKey)
            dataCounter+=1
        } catch  {
            print("Unable to Encode User: (\(error))")
        }
    }
    
    func loadusers()->Array<User>?{
        if let data = UserDefaults.standard.data(forKey: currentRecordKey) {
            do {
                let users = try decoder.decode(Array<User>.self, from: data)
                return users

            } catch {
                print("Unable to Decode User (\(error))")
            }
        }
        return nil
    }
    
    func clear(){
        self.preferences.removeObject(forKey: currentRecordKey)

    }

    

    
    


}
