//
//  CardModel.swift
//  Memory Game
//
//  Created by user196685 on 5/8/21.
//

import Foundation

class CardModel{
    func getCards()->[Card]{
        var generatedNumbersarray=[Int]()
        var generatedCardsArray=[Card]()
        
        while generatedNumbersarray.count<10 {
            let randomNumber=arc4random_uniform(10)+1
            print(randomNumber)
            if generatedNumbersarray.contains(Int(randomNumber))==false{
                generatedNumbersarray.append(Int(randomNumber))
                let cardOne = Card()
                cardOne.imageName = "card\(randomNumber)"
                
                generatedCardsArray.append(cardOne)
                
                let cardTwo = Card()
                cardTwo.imageName = "card\(randomNumber)"
                
                generatedCardsArray.append(cardTwo)
            }

            
        }
        
        for i in 0...generatedCardsArray.count-1{
            let randomNum=Int(arc4random_uniform(UInt32(generatedCardsArray.count)))
            let tmp=generatedCardsArray[i]
            
            generatedCardsArray[i]=generatedCardsArray[randomNum]
            generatedCardsArray[randomNum]=tmp
        
        }
        
        return generatedCardsArray
        
    }
}
