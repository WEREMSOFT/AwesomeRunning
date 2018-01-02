import UIKit
import SceneKit

class MapView3D:UIViewController {
   
    let scene = SCNScene()
    let view3d = SCNView()
    var phase: Float = Float(0)
    var positions = [SCNNode]()
    
    let container = SCNNode()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScene()
        setupCamera()
        //simulateDots()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if(UserPositions.positions.count > positions.count){
            for n in positions.count...(UserPositions.positions.count-1) {
                let node = createDot()
                
                node.position.x = UserPositions.positions[n].latitude * 1000
                node.position.y = UserPositions.positions[n].longitude * 1000
                node.position.z = UserPositions.positions[n].elevation
                addDot(node)

            }
        }
        
    }
    
    fileprivate func createDot() -> SCNNode {
        let geometry = SCNSphere(radius: 0.1)
        let node = SCNNode(geometry: geometry)
        return node
    }
    
    fileprivate func setupCamera(){
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(0, 0, 40)
        scene.rootNode.addChildNode(cameraNode)
    }
    
    fileprivate func setupScene() {
        view3d.scene = scene
        view3d.allowsCameraControl = true;
        view3d.autoenablesDefaultLighting = true;
        view3d.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        scene.rootNode.addChildNode(container)
        self.view = view3d
    }
    
    fileprivate func addDot(_ node: SCNNode) {
        
        positions.append(node)
        var avgPosition = SCNVector3()
        for p in positions {
            avgPosition.x += p.position.x
            avgPosition.y += p.position.y
            avgPosition.z += p.position.z
        }
        
        avgPosition.x = -avgPosition.x / Float(positions.count)
        avgPosition.y = -avgPosition.y / Float(positions.count)
        avgPosition.z = -avgPosition.z / Float(positions.count)
        
        container.position = avgPosition
        
        container.addChildNode(node)
    }
    
    func simulateDots() {
        for _ in 1...100 {
            let geometry = SCNSphere(radius: 2)
            let node = SCNNode(geometry: geometry)
            
            node.position.x = Float(arc4random_uniform(100))
            node.position.y = Float(arc4random_uniform(100))
            node.position.z = Float(arc4random_uniform(100))
            
            addDot(node)
        }
    }
    
    
    
}

