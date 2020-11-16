//
//  SFMenuAnimating.swift
//  SFSideMenuViewController
//  Created by Saifullah on 15/11/2020.
//  Copyright © 2020 Saifullah Ilyas. All rights reserved.
//

//import Foundation
import UIKit

public protocol SFMenuAnimating {
    
    func openDrawer(_ side: SFMenuSide, drawerView: UIView, centerView: UIView, animated: Bool, complete: @escaping (Bool) -> Void)
    
    func dismissDrawer(_ side: SFMenuSide, drawerView: UIView, centerView: UIView, animated: Bool, complete: @escaping (Bool) -> Void)
    
    
    /**
     *  Called prior to a rotation event, while a drawer view is being shown.
     *
     *  @param side The currently open drawer side
     *  @param the containing side view that is shown.
     *  @param the containing centre view.
     */
    func willRotateWithDrawerOpen(_ side: SFMenuSide, drawerView: UIView, centerView: UIView)
    
    /**
     *  Called following a rotation event, while a drawer view is being shown.
     *
     *  @param side The currently open drawer side
     *  @param the containing side view that is shown.
     *  @param the containing centre view.
     *  @param a complete block handler to handle cleanup.
     */
    func didRotateWithDrawerOpen(_ side: SFMenuSide, drawerView: UIView, centerView: UIView)
    
}
