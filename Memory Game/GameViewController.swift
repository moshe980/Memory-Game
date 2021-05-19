import UIKit
import CoreLocation

class GameViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var moveCounterLabel: UILabel!
    
    var model=CardModel()
    var cardArray=[Card]()
    var locationManager:CLLocationManager!
    var userName:String!
    
    var moveCounter=20
    var firstFlippedCardIndex:IndexPath?
    
    var timer:Timer?
    var milliseconds:Float=0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardArray=model.getCards()
        
        collectionView.delegate=self
        collectionView.dataSource=self
        
        locationManager=CLLocationManager()
        locationManager.delegate=self

        
        timer=Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        moveCounterLabel.text="Moves: \(moveCounter)"

        RunLoop.main.add(timer!, forMode: .common)
    }
    

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    @objc func timerElapsed(){
        milliseconds+=1
        
        let seconds=String(format: "%.2f",milliseconds/1000)
        
        timerLabel.text=seconds

        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as! CardCollectionViewCell
        
        let card=cardArray[indexPath.row]
        cell.setCard(card)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if moveCounter<=0{
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
            moveCounter-=1
            moveCounterLabel.text="Moves: \(moveCounter)"
            checkGameEnded()

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
            if moveCounter>0{
                timer?.invalidate()
            }
            title="Congratulations!"
            message="You won!!!\n Enter your name:"
            showTextViewAlret(title,message)

        }else{
            
            if moveCounter>0{
                return
            }
            timer?.invalidate()
            
            title="Game Over!"
            message="You lost"
            firstFlippedCardIndex=nil
            showAlret(title,message)
        }
    }
    
    func showAlret(_ title:String,_ message:String){
        let alret=UIAlertController(title: title, message: message, preferredStyle: .alert)
 
        alret.addAction(UIAlertAction(title: "Ok", style: .default, handler:{(_) in
            self.dismiss(animated: true, completion: nil)
        } ))

        present(alret, animated: true, completion: nil)
    }
    func showTextViewAlret(_ title:String,_ message:String){
        let textAlretView=UIAlertController(title: title, message: message, preferredStyle: .alert)
        textAlretView.addTextField(configurationHandler: nil)
        textAlretView.addAction(UIAlertAction(title: "Submit", style: .default, handler: { (_) in
        self.userName = textAlretView.textFields![0].text
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestLocation()



        }))
        
        present(textAlretView, animated: true, completion: nil)

    }

}
extension GameViewController:CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location=locations.last{
            locationManager.stopUpdatingLocation()
            let lat=location.coordinate.latitude
            let lon=location.coordinate.longitude
            
            ModelManager.instance.saveUser(user: User(name:userName, score: Double(self.timerLabel.text!)!,lat: lat,lon: lon))
            
            
        }
        self.dismiss(animated: true, completion: nil)

    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("location Error:\(Error.Type.self)")
        print(CLLocationManager.locationServicesEnabled())
        self.dismiss(animated: true, completion: nil)

    }
    
}

