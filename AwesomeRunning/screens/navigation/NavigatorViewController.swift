import UIKit

class NavigationViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapViewController = MapViewController()
        
        mapViewController.title = "Map View"
        mapViewController.tabBarItem.image = "\u{f278}".image(nil)
        
        let loadingController = LoadViewController()
        
        loadingController.title = "Awesome Runner"
        loadingController.tabBarItem.image = "\u{f017}".image(nil)

        let mapView3DController = MapView3D()
        
        mapView3DController.title = "3D Map"
        mapView3DController.tabBarItem.image = "\u{f1b2}".image(nil)
        
        tabBar.isTranslucent = false
        tabBar.clipsToBounds = true
        viewControllers = [mapViewController,  mapView3DController, loadingController]
        
        
        let topLayer = CALayer()
        topLayer.frame = CGRect(x: 0, y: 0, width: 1000, height: 0.5)
        topLayer.backgroundColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1).cgColor
        tabBar.layer.addSublayer(topLayer)
    }
    
}
