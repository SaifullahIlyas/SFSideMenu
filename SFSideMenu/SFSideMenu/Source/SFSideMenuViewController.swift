//
//  SFSideMenuViewController.swift
//  SFSideMenuViewController
//  Created by Saifullah on 15/11/2020.
//  Copyright © 2020 Saifullah Ilyas. All rights reserved.
//

import UIKit

public enum SFMenuSide: CGFloat {
    case none  = 0
    case left  = 1
    case right = -1
}

open class SFSideMenuViewController: UIViewController {
    
    let defaultDuration:TimeInterval = 0.3
    
    // MARK: Initialization
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func loadView() {
        initStyles()
        
        
    }
    
    private func initStyles(){
        //MARK:- Apply Same background color to menu mac image as like left View controller
        drawerView.backgroundImageView.backgroundColor = leftViewController?.view.backgroundColor
        leftViewController?.view.backgroundColor = .clear
        view = drawerView
    }
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //let replector = (leftViewController?.view.layer)!
        drawerView.backgroundImageView.layer.insertSublayer(_gradientLayer!, at: 0)
        leftViewController?.view.layer.insertSublayer(_gradientLayer!, at: 0)
    }
    
    fileprivate var _drawerView: SFMenuView?
    var drawerView: SFMenuView {
        get {
            if let retVal = _drawerView {
                return retVal
            }
            let rect = UIScreen.main.bounds
            let retVal = SFMenuView(frame: rect)
            _drawerView = retVal
            return retVal
        }
    }
    
    // TODO: Add ability to supply custom animator.
    
    fileprivate var _animator: SFSpringAnimator?
    open var animator: SFSpringAnimator {
        get {
            if let retVal = _animator {
                return retVal
            }
            let retVal = SFSpringAnimator()
            _animator = retVal
            return retVal
        }
    }
    
    // MARK: Interaction
    
    @nonobjc open func show(viewController : UIViewController){
        DispatchQueue.main.async {
            self.closeDrawer(self.currentlyOpenedSide, animated: true) { (finished) -> Void in
                
                //Nothing To DO for Now...
            }
            if let topVC = self.centerViewController as? UINavigationController {
                
                if topVC.topViewController != viewController && topVC.topViewController != self.rightViewController && topVC.topViewController != self.leftViewController {
                    topVC.pushViewController(viewController, animated: false)
                }
                
                
            }
            else{
                viewController.modalTransitionStyle = .crossDissolve
                viewController.modalPresentationStyle = .fullScreen
                self.present(viewController, animated: true, completion: nil)
            }
            
        }
        
        
    }
    open func openDrawer(_ side: SFMenuSide, animated:Bool, complete: @escaping (Bool) -> Void) {
        if currentlyOpenedSide != side {
            if let sideView = drawerView.viewContainerForDrawerSide(side) {
                let centerView = drawerView.centerViewContainer
                if currentlyOpenedSide != .none {
                    closeDrawer(side, animated: animated) { finished in
                        self.animator.openDrawer(side, drawerView: sideView, centerView: centerView, animated: animated, complete: complete)
                    }
                } else {
                    
                    self.animator.openDrawer(side, drawerView: sideView, centerView: centerView, animated: animated, complete: complete)
                }
                
                addDrawerGestures()
                drawerView.willOpenDrawer(self)
            }
        }
        
        currentlyOpenedSide = side
    }
    
    open func closeDrawer(_ side: SFMenuSide, animated: Bool, complete: @escaping (Bool) -> Void) {
        if (currentlyOpenedSide == side && currentlyOpenedSide != .none) {
            if let sideView = drawerView.viewContainerForDrawerSide(side) {
                let centerView = drawerView.centerViewContainer
                animator.dismissDrawer(side, drawerView: sideView, centerView: centerView, animated: animated, complete: complete)
                currentlyOpenedSide = .none
                restoreGestures()
                drawerView.willCloseDrawer(self)
            }
        }
    }
    
    open func toggleDrawer(_ side: SFMenuSide, animated: Bool, complete: @escaping (_ finished: Bool) -> Void) {
        if side != .none {
            if side == currentlyOpenedSide {
                closeDrawer(side, animated: animated, complete: complete)
            } else {
                openDrawer(side, animated: animated, complete: complete)
            }
        }
    }
    
    // MARK: Gestures
    
    func addDrawerGestures() {
        centerViewController?.view.isUserInteractionEnabled = false
        drawerView.centerViewContainer.addGestureRecognizer(toggleDrawerTapGestureRecognizer)
    }
    
    func restoreGestures() {
        drawerView.centerViewContainer.removeGestureRecognizer(toggleDrawerTapGestureRecognizer)
        centerViewController?.view.isUserInteractionEnabled = true
    }
    
    @objc func centerViewContainerTapped(_ sender: AnyObject) {
        closeDrawer(currentlyOpenedSide, animated: true) { (finished) -> Void in
            // Do nothing
        }
    }
    
    // MARK: Helpers
    
    func viewContainer(_ side: SFMenuSide) -> UIViewController? {
        switch side {
        case .left:
            return self.leftViewController
        case .right:
            return self.rightViewController
        case .none:
            return nil
        }
    }
    
    func replaceViewController(_ sourceViewController: UIViewController?, destinationViewController: UIViewController, container: UIView) {
        
        sourceViewController?.willMove(toParent: nil)
        sourceViewController?.view.removeFromSuperview()
        sourceViewController?.removeFromParent()
        
        self.addChild(destinationViewController)
        container.addSubview(destinationViewController.view)
        
        let destinationView = destinationViewController.view
        destinationView?.translatesAutoresizingMaskIntoConstraints = false
        
        container.removeConstraints(container.constraints)
        
        let views: [String:UIView] = ["v1" : destinationView!]
        container.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v1]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
        container.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v1]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
        
        destinationViewController.didMove(toParent: self)
    }
    
    // MARK: Private computed properties
    
    open var currentlyOpenedSide: SFMenuSide = .none
    
    // MARK: Accessors
    fileprivate var _leftViewController: UIViewController?
    open var leftViewController: UIViewController? {
        get {
            return _leftViewController
        }
        set {
            self.replaceViewController(self.leftViewController, destinationViewController: newValue!, container: self.drawerView.leftViewContainer)
            _leftViewController = newValue!
        }
    }
    
    fileprivate var _rightViewController: UIViewController?
    open var rightViewController: UIViewController? {
        get {
            return _rightViewController
        }
        set {
            self.replaceViewController(self.rightViewController, destinationViewController: newValue!, container: self.drawerView.rightViewContainer)
            _rightViewController = newValue
        }
    }
    
    fileprivate var _centerViewController: UIViewController?
    open var centerViewController: UIViewController? {
        get {
            return _centerViewController
        }
        set {
            self.replaceViewController(self.centerViewController, destinationViewController: newValue!, container: self.drawerView.centerViewContainer)
            _centerViewController = newValue
        }
    }
    
    fileprivate lazy var toggleDrawerTapGestureRecognizer: UITapGestureRecognizer = {
        [unowned self] in
        let gesture = UITapGestureRecognizer(target: self, action: #selector(SFSideMenuViewController.centerViewContainerTapped(_:)))
        return gesture
        }()
    
    open var leftDrawerWidth: CGFloat {
        get  {
            return drawerView.leftViewContainerWidth
        }
        set {
            drawerView.leftViewContainerWidth = newValue
        }
    }
    
    open var rightDrawerWidth: CGFloat {
        get {
            return drawerView.rightViewContainerWidth
        }
        set {
            drawerView.rightViewContainerWidth = newValue
        }
    }
    
    open var leftDrawerRevealWidth: CGFloat {
        get {
            return drawerView.leftViewContainerWidth
        }
    }
    
    open var rightDrawerRevealWidth: CGFloat {
        get {
            return drawerView.rightViewContainerWidth
        }
    }
    
    open var backgroundImage: UIImage? {
        get {
            return drawerView.backgroundImageView.image
        }
        set {
            drawerView.backgroundImageView.image = newValue
        }
    }
    
    //MARK:- Gradient  layer
    /* fileprivate  lazy var _gradientLayer : CAGradientLayer? = {
     let backgroundEffect = CAGradientLayer()
     backgroundEffect.colors = self.gradientColors != nil ? self._gradientColors : [self.leftViewController?.view.layer.backgroundColor as Any]
     backgroundEffect.locations = [0.0,1.0]
     backgroundEffect.frame = self.drawerView.backgroundImageView.frame
     return backgroundEffect
     }()*/
    fileprivate  var _gradientLayer : CAGradientLayer? {
        let backgroundEffect = CAGradientLayer()
        backgroundEffect.colors = self.gradientColors != nil ? self._gradientColors : [self.leftViewController?.view.layer.backgroundColor as Any]
        backgroundEffect.locations = [0.0,1.0]
        backgroundEffect.frame = self.drawerView.backgroundImageView.frame
        return backgroundEffect
    }
    fileprivate var  _gradientColors : [CGColor]?
    open var gradientColors : [CGColor]?{
        get{
            return _gradientColors
        }
        set{
            _gradientColors = newValue
        }
    }
    
    // MARK: Status Bar
    
    override open var childForStatusBarHidden : UIViewController? {
        return centerViewController
    }
    
    override open var childForStatusBarStyle : UIViewController? {
        return centerViewController
    }
    
    // MARK: Memory Management
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
