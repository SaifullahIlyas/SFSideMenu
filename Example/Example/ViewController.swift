//
//  ViewController.swift
//  Example
//
//  Created by SAIF ULLAH on 08/03/2021.
//

import UIKit
import SFSideMenu

class ViewController: UIViewController {
    
    
   class func  instance()->Self {
   return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! Self
    }
    var drawer : SFSideMenuViewController = SFSideMenuViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
    }

    @IBAction func toggle(_ sender: Any) {
        let _drawer = (UIApplication.shared.delegate as! AppDelegate)._drawerViewController
        _drawer?.openDrawer(.left, animated: true, complete: { _ in
            
        })
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
}

class LeftMenuview : UIViewController {
    var frame : CGRect!
    init(frame : CGRect) {
        super.init(nibName: nil, bundle: nil)
        self.frame = frame
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func loadView() {
        let rightView = UIView(frame: frame)
        rightView.backgroundColor = .black
        self.view = rightView
    }
}
//class RightVC : UIViewController {
//    var frame : CGRect!
//    init(frame : CGRect) {
//        super.init(nibName: nil, bundle: nil)
//        self.frame = frame
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    override func loadView() {
//        let rightView = UIView(frame: frame)
//        rightView.backgroundColor = .black
//        self.view = rightView
//    }
//}
class ScaledHeightImageView: UIImageView {

    override var intrinsicContentSize: CGSize {

        if let myImage = self.image {
            let myImageWidth = myImage.size.width
            let myImageHeight = myImage.size.height
            let myViewWidth = self.frame.size.width
 
            let ratio = myViewWidth/myImageWidth
            let scaledHeight = myImageHeight * ratio

            return CGSize(width: myViewWidth, height: scaledHeight)
        }

        return CGSize(width: -1.0, height: -1.0)
    }

}
