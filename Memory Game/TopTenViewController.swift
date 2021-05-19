import UIKit
import MapKit

class TopTenViewController: UIViewController {


    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    
    var users=[User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate=self
        tableView.dataSource=self
        
       // ModelManager.instance.clear()
        print(ModelManager.instance.size())
        if ModelManager.instance.loadusers() != nil{
            users=ModelManager.instance.loadusers()!
        }

        
    }
    
    

}
extension TopTenViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text="\(indexPath.row+1)) Name: \(users[indexPath.row].getName())"
        cell.detailTextLabel?.text="     Score: \(users[indexPath.row].getScore())"
        return cell

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(users[indexPath.row].getLat())
        let annontation=MKPointAnnotation()
        annontation.coordinate=CLLocationCoordinate2DMake(users[indexPath.row].getLat(), users[indexPath.row].getLon())
        annontation.title=users[indexPath.row].getName()
        annontation.subtitle="\(users[indexPath.row].getScore())"

        mapView.addAnnotation(annontation)
        
        let region=MKCoordinateRegion(center: annontation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
    }
}
