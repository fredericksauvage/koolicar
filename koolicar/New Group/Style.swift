//
//  Style.swift
//  koolicar
//
//  Created by frederick sauvage on 17-10-04.
//  Copyright © 2017 frederick sauvage. All rights reserved.
//

import Foundation
import UIKit

class Style {
    
    static func greenKoolicar() -> UIColor {
        return UIColor(red: 132/255, green: 255/255, blue: 221/255, alpha: 1.00)
    }
    
    static func purpleKoolicar() -> UIColor {
        return UIColor(red: 204/255, green: 102/255, blue: 255/255, alpha: 1.00)
    }
    
    static func grayLightKoolicar() -> UIColor {
        return UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.00)
    }
    
    static func grayDarkKoolicar() -> UIColor {
        return UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1.00)
    }
    
    static func opacKoolicar() -> UIColor {
        return UIColor(red: 132/255, green: 255/255, blue: 221/255, alpha: 0.5)
    }
    
    static func toolbarBackgroundColor() -> UIColor {
        return  UIColor(red: 0, green: 0, blue: 0, alpha: 1.00)
    }
    
    static func buttonDefaultFrontColor() -> UIColor {
        return  UIColor(red: 132/255, green: 255/255, blue: 221/255, alpha: 1.00)
    }
    
    static func buttonDefaultBackgroundColor() -> UIColor {
        return  Style.greenKoolicar()
    }
    
    static func button(imageName: String? = nil, title: String? = nil , frontColor: UIColor = Style.buttonDefaultFrontColor(), backgroundColor: UIColor = Style.buttonDefaultBackgroundColor(), radiusHeightMultiplier: CGFloat = 0) -> UIButton {
        let button = UIButton(type: .system)
        if let imageName = imageName {
            button.setImage(UIImage(named: imageName), for: UIControlState())
        }
        if let title = title {
            button.setTitle(title.localizedLowercase, for: .normal)
        }
        button.tintColor = frontColor
        button.backgroundColor = backgroundColor
        button.frame = CGRect(x: 0, y: 0, width: 80, height: 30)
        button.layer.cornerRadius = button.frame.height * radiusHeightMultiplier
        return  button
    }
    
    static func barButton(imageName: String? = nil, title: String? = nil , frontColor: UIColor = Style.buttonDefaultFrontColor(), backgroundColor: UIColor = Style.buttonDefaultBackgroundColor(), radiusHeightMultiplier: CGFloat = 0) -> UIBarButtonItem {
        let button = Style.button(imageName: imageName, title: title, frontColor: frontColor, backgroundColor: backgroundColor, radiusHeightMultiplier: radiusHeightMultiplier)
        return  UIBarButtonItem(customView: button)
    }
    
    static func selectadColorButton(isSelected: Bool) -> UIColor {
        guard isSelected else { return Style.grayLightKoolicar() }
        return Style.greenKoolicar()
    }
}
