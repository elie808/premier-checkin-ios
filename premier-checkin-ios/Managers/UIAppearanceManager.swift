//
//  UIAppearanceManager.swift
//  premier-checkin-ios
//
//  Created by Elie El Khoury on 10/6/18.
//  Copyright © 2018 Elie El Khoury. All rights reserved.
//

import UIKit
import SVProgressHUD

final class UIAppearanceManager {
    
    static func customize() {
        
//        // Status Bar Appearance
        UIApplication.shared.statusBarStyle = .lightContent
//
//        // UITabBarItem Appearance
//        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.butlrBlack], for: .normal)
//        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.butlrBlack], for: .selected)
//
//        // UIBarButtonItem Appearance
//        UIBarButtonItem.appearance(whenContainedInInstancesOf:[UISearchBar.self]).tintColor = UIColor.butlrWhite
//
//        // UISearchBar Appearance
//        UISearchBar.appearance().tintColor = UIColor.butlrBlack
//        UISearchBar.appearance().barTintColor = UIColor.butlrBlack
//
//        // UITabBar Appearance
//        UITabBar.appearance().tintColor = UIColor.butlrBlack
//        UITabBar.appearance().barTintColor = UIColor.butlrWhite
//        UITabBar.appearance().unselectedItemTintColor = UIColor.tabItemTitleTint
//
//        // UINavigationBar Appearance
//        UINavigationBar.appearance().tintColor = UIColor.white
//        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
//        UINavigationBar.appearance().barTintColor = UIColor.butlrBlack
//        UINavigationBar.appearance().isTranslucent = false
//        UINavigationBar.appearance().barStyle = .black
//        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
//        UINavigationBar.appearance().shadowImage = UIImage()
//
//        // SVProgressHUD Appearance
//        SVProgressHUD.setDefaultStyle(.custom)
//        SVProgressHUD.setDefaultMaskType(.clear)
//        SVProgressHUD.setForegroundColor(UIColor.butlrBlack)
//        SVProgressHUD.setBackgroundColor(UIColor.clear)
//        SVProgressHUD.setDefaultAnimationType(.flat)
//        SVProgressHUD.setMinimumDismissTimeInterval(1.0)
//        SVProgressHUD.setHapticsEnabled(true)
    }
}

// MARK: - Extensions

extension UIView {
    
    func applyKeyboardButtonGradient() {
        
        let gradient = CAGradientLayer()
        gradient.colors = [#colorLiteral(red: 0.1960784314, green: 0.2470588235, blue: 0.3843137255, alpha: 1).cgColor, #colorLiteral(red: 0.3529411765, green: 0.4039215686, blue: 0.5411764706, alpha: 1).cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.frame = self.bounds
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func addRoundedCorners() {
        self.layer.cornerRadius = self.bounds.size.height / 2.0
        self.layer.masksToBounds = true
    }
    
    func addBorder(width: CGFloat, color: UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
        self.layer.masksToBounds = true
    }
}
