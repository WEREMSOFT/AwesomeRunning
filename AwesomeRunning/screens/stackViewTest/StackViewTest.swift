import UIKit
import MapKit

class StacViewTest: UIViewController {
    fileprivate func setupNavigatorAttributes() {
        self.title = "Map View"
        self.tabBarItem.image = "\u{f278}".image(nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigatorAttributes()
        
        let viewBlue = MKMapView()
        
        let viewRed = UIView(frame: view.frame)
        viewRed.backgroundColor = .red
 
        let viewGreen = UIView(frame: view.frame)
        viewGreen.backgroundColor = .green
        
        let stackView = UIStackView(arrangedSubviews: [viewRed, viewBlue, viewGreen])
        
        stackView.frame = view.frame
        
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        
        view.addSubview(stackView)
       
    }
}
