import UIKit

class LoadViewController: UIViewController, CAAnimationDelegate {
    
    let shapeLayer = CAShapeLayer()
    let pathLayer = CAShapeLayer()
    let percentageLabel:UILabel = {
        let label = UILabel()
        label.text = "Start"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        label.textColor = UIColor.white
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(percentageLabel)
        percentageLabel.center = view.center
        
        view.backgroundColor = UIColor.black
        
        initGestureRecognizers()
        initShapeLayer()
        drawCircle()
        //ShowLoadingMessage()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        triggerLoadingAnimation()
    }
    
    fileprivate func initGestureRecognizers(){
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler)))
    }
    
    fileprivate func triggerLoadingAnimation() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 1
        animation.duration = 1
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        animation.delegate = self
        shapeLayer.add(animation, forKey: "urSoBasic")
    }
    
    @objc fileprivate func tapGestureHandler(){
        print("tap!!")
        triggerLoadingAnimation()
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        //performSegue(withIdentifier: "toMap", sender: nil)
    }
    
    fileprivate func initShapeLayer(){
        
        pathLayer.position = view.center
        view.layer.addSublayer(pathLayer)
        pathLayer.fillColor = UIColor.clear.cgColor
        
        shapeLayer.position = view.center
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        view.layer.addSublayer(shapeLayer)
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.fillColor = UIColor.clear.cgColor
        
    }
    
    fileprivate func drawCircle(){
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        pathLayer.strokeColor = UIColor.darkGray.cgColor
        pathLayer.lineWidth = 10
        pathLayer.strokeEnd = 1
        pathLayer.path = circularPath.cgPath
        
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.strokeEnd = 0
        shapeLayer.path = circularPath.cgPath
    }
    
    fileprivate func ShowLoadingMessage() {
        let messages = ["Sending your bitcoins...", "Uploading your personal data...", "Minig bitconins..."]
        
        let textLabelView = UILabel(frame: CGRect(x: 0, y: 0, width: 500, height: 100))
        
        textLabelView.translatesAutoresizingMaskIntoConstraints =  false
        let index = UInt32(messages.count)
        textLabelView.text = messages[Int(arc4random_uniform(index))]
        textLabelView.textColor = UIColor.white
        textLabelView.font = UIFont(name: "Verdana", size: 18)
        textLabelView.adjustsFontSizeToFitWidth = true
        textLabelView.textAlignment = .center
        
        view.addSubview(textLabelView)
        textLabelView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textLabelView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        textLabelView.widthAnchor.constraint(equalToConstant: view.frame.width / 2).isActive = true
    }
}
