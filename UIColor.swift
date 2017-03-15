//
//  UIColor.swift
//  FriendForFare
//
//  Created by Visarut on 12/4/2559 BE.
//  Copyright © 2559 BE Newfml. All rights reserved.
//

import UIKit

extension UIColor {
    func as1ptImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        let ctx = UIGraphicsGetCurrentContext()
        self.setFill()
        ctx!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func toImage() -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
        self.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    //    public class func appColor() -> UIColor {
    //        let appColor = UIColor(red: 64/255.0, green: 157/255.0, blue: 151/255.0, alpha: 1.0)
    //        return appColor
    //    }
    
    
    public class var borderImage: UIColor {
    let borderImage = UIColor(red: 240 / 255, green: 240 / 255, blue: 240 / 255, alpha: 0.0)
    return borderImage
    }
    
    public class var backgroundImage: UIColor {
        let backgroundImage = UIColor(red: 240 / 255, green: 240 / 255, blue: 240 / 255, alpha: 1.0)
        return backgroundImage
    }
    
    public class var textfield: UIColor {
        let textfield = UIColor(red: 238 / 255, green: 238 / 255, blue: 238 / 255, alpha: 1.0)
        return textfield
    }
    
    public class var redBT: UIColor {
        let cancelbt = UIColor(red: 223 / 255, green: 54 / 255, blue: 54 / 255, alpha: 1.0)
        return cancelbt
    }
    
    public class var greenBT: UIColor {
        let greenColor = UIColor(red: 26 / 255, green: 183 / 255, blue: 137 / 255, alpha: 1.0)
        return greenColor
    }
    
    public class var tabbarColor: UIColor {
        let tabbarColor = UIColor(red: 255 / 255, green: 205 / 255, blue: 0 / 255, alpha: 1.0)
        return tabbarColor
    }
    
    public class var sectionColor: UIColor {
        let sectionColor = UIColor(red: 236 / 255, green: 239 / 255, blue: 241 / 255, alpha: 1.0)
        return sectionColor
    }
    
    public class var tabColor: UIColor {
        let tabColor = UIColor(red: 33 / 255, green: 33 / 255, blue: 33 / 255, alpha: 1.0)
        return tabColor
    }
    
    public class var searchbarColor: UIColor {
        let searchbarColor = UIColor(red: 207 / 255, green: 216 / 255, blue: 220 / 255, alpha: 1.0)
        return searchbarColor
    }
    
    public class var systemColor: UIColor {
        let darkGray = UIColor(red: 58 / 255, green: 58 / 255, blue: 58 / 255, alpha: 1.0)
        return darkGray
    }
    
    public class var unSelectedColor: UIColor {
        let unSelectedColor = UIColor(red: 73/255.0, green: 8/255.0, blue: 10/255.0, alpha: 1.0)
        return unSelectedColor
    }
    
    public class var graySpotifyColor: UIColor {
        let graySpotifyColor = UIColor(red: 21/255.0, green: 21/255.0, blue: 24/255.0, alpha: 1.0)
        return graySpotifyColor
    }
    
    public class var darkGraySpotifyColor: UIColor {
        let darkGraySpotifyColor = UIColor(red: 19/255.0, green: 20/255.0, blue: 20/255.0, alpha: 1.0)
        return darkGraySpotifyColor
    }
    
    public class var greenHilightColor: UIColor {
        let greenHilightColor = UIColor(red: 33/255.0, green: 174/255.0, blue: 67/255.0, alpha: 1.0)
        return greenHilightColor
    }
    
    public class var mostLightGrayColor: UIColor {
        let mostLightGrayColor = UIColor(red: 250/255.0, green: 250/255.0, blue: 250/255.0, alpha: 1.0)
        return mostLightGrayColor
    }
    
    public class var veryLightGrayColor: UIColor {
        let veryLightGrayColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        return veryLightGrayColor
    }
    
    public class var greyPlaceholderColor: UIColor {
        let greyPlaceholderColor = UIColor(red: 199/255.0, green: 199/255.0, blue: 205/255.0, alpha: 1.0)
        return greyPlaceholderColor
    }
    
    public class var turquoiseColor: UIColor {
        let turquoiseColor = UIColor(red: 25/255.0, green: 181/255.0, blue: 188/255.0, alpha: 1.0)
        return turquoiseColor
    }
    
    public class var nineNineGrayColor: UIColor {
        let nineNineGrayColor = UIColor(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1.0)
        return nineNineGrayColor
    }
}

class NavController: UINavigationController {
    
//    override var preferredStatusBarStyle : UIStatusBarStyle {
//        return .lightContent
//    }
    
//    override var navigationBar: UINavigationBar {
//        self.navigationBar.tintColor = UIColor.yellow
//        return navigationBar
//    }
}

class TabBarController : UITabBarController {
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}
