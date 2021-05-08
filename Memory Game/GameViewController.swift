import UIKit

class GameViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var model=CardModel()
    var cardArray=[Card]()
    
    var firstFlippedCardIndex:IndexPath?
    
    var timer:Timer?
    var milliseconds:Float=1000*30//30 seconds
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardArray=model.getCards()
        
        collectionView.delegate=self
        collectionView.dataSource=self
        
        timer=Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)

        RunLoop.main.add(timer!, forMode: .common)
    }
    

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return cardArray.count
    }
    
    @objc func timerElapsed(){
        milliseconds-=1
        
        let seconds=String(format: "%.2f",milliseconds/1000)
        
        timerLabel.text=seconds
        
        if milliseconds<=0{
            timer?.invalidate()
            
            timerLabel.textColor=UIColor.red
            
            checkGameEnded()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as! CardCollectionViewCell
        
        let card=cardArray[indexPath.row]
        cell.setCard(card)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if milliseconds<=0{
            return
        }
        let cell=collectionView.cellForItem(at: indexPath)as! CardCollectionViewCell
        
        let card=cardArray[indexPath.row]
        
        if card.isFlipped==false&&card.isMatched==false{
            
            card.isFlipped=true
            cell.flip()
            
            if firstFlippedCardIndex==nil{
                firstFlippedCardIndex=indexPath
            }else{
                checkForMatches(indexPath)
            }

        }
    }
    
    func checkForMatches(_ secondFlippedCardIndex:IndexPath){
        let cardOneCell=collectionView.cellForItem(at: firstFlippedCardIndex!)as? CardCollectionViewCell
        let cardTwoCell=collectionView.cellForItem(at: secondFlippedCardIndex)as? CardCollectionViewCell
        
        let cardOne=cardArray[firstFlippedCardIndex!.row]
        let cardTwo=cardArray[secondFlippedCardIndex.row]
        
        if cardOne.imageName==cardTwo.imageName{
            cardOne.isMatched=true
            cardTwo.isMatched=true

            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            checkGameEnded()

        }else{
            cardOne.isFlipped=false
            cardTwo.isFlipped=false
            
            cardOneCell?.flipBack()
            cardTwoCell?.flipBack()
        }
        
        if cardOneCell==nil{
            collectionView.reloadItems(at: [firstFlippedCardIndex!])
        }
        firstFlippedCardIndex=nil

    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardArray.count

    }
    
    func checkGameEnded(){
        var isWon=true
        
        for card in cardArray{
            if card.isMatched==false{
                isWon=false
                break
            }
        }
        var title=""
        var message=""
        
        if isWon==true{
            if milliseconds>0{
                timer?.invalidate()
            }
            title="Congratulations!"
            message="You won"
        }else{
            
            if milliseconds>0{
                return
            }
            title="Game Over!"
            message="You lost"

        }
        showAlret(title,message)
    }
    
    func showAlret(_ title:String,_ message:String){
        let alret=UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alretAction=UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alret.addAction(alretAction)
        present(alret, animated: true, completion: nil)
    }
}

