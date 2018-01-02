import UIKit
extension String {
    func image(_ imageSize: CGSize?) -> UIImage {
        var size: CGSize
        if( imageSize == nil) {
            size = CGSize(width: 30, height: 30)
        } else {
            size = imageSize!
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0);
        UIColor.clear.set()
        let rect = CGRect(origin: CGPoint.zero, size: size)
        UIRectFill(CGRect(origin: CGPoint.zero, size: size))
        let fontawesome:UIFont? = UIFont(name: "FontAwesome", size: size.width * 0.7)
        if fontawesome != nil {
            (self as NSString).draw(in: rect, withAttributes: [NSAttributedStringKey.font: fontawesome!])
        } else {
            (self as NSString).draw(in: rect)
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
}

