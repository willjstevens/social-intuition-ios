//
//  Utils.swift
//  SocialIntuition
//
//  Created by Will Stevens on 4/22/17.
//  Copyright © 2017 Social Intuition. All rights reserved.
//

import Foundation
import UIKit

class Utils
{
    static var stackViewSpacingLookup: [UIStackView: CGFloat] = [:]
    
    static func loadImage(sourceImageInfo: StoredImageInfo?, targetImageView: UIImageView) {
        if let imageInfo = sourceImageInfo {
            let url = URL(string: imageInfo.secureUrl!)
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url!) { //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                    DispatchQueue.main.async {
                        targetImageView.image = UIImage(data: data)!
                    }
                }
            }
        }
    }
    
    static func setImageAsync(imageView: UIImageView, newImage: UIImage) {
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                imageView.image = newImage
            }
        }
    }
    
    static func setVisibility(constraint: SiNSLayoutConstraint, isVisible: Bool) {
        if isVisible {
            constraint.siShow()
        } else {
            constraint.siHide()
        }
    }
    
    static func setVisibility(view: UIView, isVisible: Bool) {
        view.alpha = isVisible ? 1 : 0
        view.isHidden = !isVisible
    }

    static func clearStackView(uiStackView: UIStackView) {
        for subview in uiStackView.arrangedSubviews {
            uiStackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
    }
    
    static func show(uiStackView: UIStackView, uiView: UIView, insertIndex: Int) {
//        print("***** show")
        uiView.isHidden = false
        uiStackView.insertArrangedSubview(uiView, at: insertIndex)
//            print("***** inserted arranged view at index \(insertIndex)")
    }
    
    static func showByAdd(uiStackView: UIStackView, uiView: UIView) {
//        print("***** add")
        uiView.isHidden = false
        uiStackView.addArrangedSubview(uiView)
//                    print("***** added arranged view")
        
        if let stackView = uiView as? UIStackView {
            
            if let spacing = stackViewSpacingLookup[stackView] {
//                print("*** spacing to reinstall = \(spacing)")
                stackView.spacing = spacing
                stackViewSpacingLookup.removeValue(forKey: stackView)
            }
        }
    }
    
    static func hide(uiStackView: UIStackView, uiView: UIView) {
//                    print("***** hide")
        uiStackView.removeArrangedSubview(uiView)
        //            uiView.removeFromSuperview() // this sets the IBOutlet to nil, use isHidden property instead
        uiView.isHidden = true
//        print("***** hid arranged view")
        
        if let stackView = uiView as? UIStackView {
            let spacing = stackView.spacing
//            print("*** spacing to remove = \(spacing)")
            stackViewSpacingLookup[stackView] = spacing
            stackView.spacing = 0
        }
    }
    
    static func animatedShow(uiStackView: UIStackView, uiView: UIView, insertIndex: Int) {
        animate {
            show(uiStackView: uiStackView, uiView: uiView, insertIndex: insertIndex)
        }
    }
    
    static func animatedShowByAdd(uiStackView: UIStackView, uiView: UIView) {
        animate {
            showByAdd(uiStackView: uiStackView, uiView: uiView)
        }
    }
    
    static func animatedHide(uiStackView: UIStackView, uiView: UIView) {
        animate {
            hide(uiStackView: uiStackView, uiView: uiView)
        }
    }
    
    static func setAnimatedVisibility(constraint: SiNSLayoutConstraint, isVisible: Bool) {
        animate {
            setVisibility(constraint: constraint, isVisible: isVisible)
        }
    }
    
    static func setAnimatedVisibility(view: UIView, isVisible: Bool) {
        animate {
            setVisibility(view: view, isVisible: isVisible)
        }
    }
    
    static func setAnimatedVisibilityWithDelay(view: UIView, isVisible: Bool, delay: TimeInterval) {
        animateWithDelay(delay: delay, subject: {
            setVisibility(view: view, isVisible: isVisible)
        })
    }
    
    static func animate(subject: @escaping () -> () ) {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            subject()
        }, completion: {_ in
        })
    }
    
    static func animateWithDelay(delay: TimeInterval, subject: @escaping () -> () ) {
        UIView.animate(withDuration: 0.25, delay: delay, options: UIView.AnimationOptions.curveEaseOut, animations: {
            subject()
        }, completion: {_ in
        })
    }
    
}

extension UIButton {
    func roundedButton(){
        let maskPAth1 = UIBezierPath(roundedRect: self.bounds,
                                     byRoundingCorners: [.topLeft , .topRight, .bottomLeft, .bottomRight],
                                     cornerRadii: CGSize(width: 4.0, height: 4.0))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = self.bounds
        maskLayer1.path = maskPAth1.cgPath
        self.layer.mask = maskLayer1
        
    }
}

extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}

extension UITableView {
    func scrollByPoints(tableView: UITableView, points: CGFloat, isUp: Bool) {

        var point = tableView.contentOffset
        point .y -= (tableView.rowHeight)
        tableView.contentOffset = point
    }
}

// from solution: http://stackoverflow.com/questions/39018017/programmatically-scroll-a-uiscrollview-to-the-top-of-a-child-uiview-subview-in
//extension UIScrollView {
//    
//    // Scroll to a specific view so that it's top is at the top our scrollview
//    func scrollToView(view: UIView, animated: Bool) {
//        if let origin = view.superview {
//            // Get the Y position of your child view
//            let childStartPoint = origin.convert(view.frame.origin, to: self)
//            // Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
//            self.setContentOffset(CGPoint(x: 0, y: childStartPoint.y), animated: animated)        }
//    }
//    
//    // Bonus: Scroll to top
//    func scrollToTop(animated: Bool) {
//        let topOffset = CGPoint(x: 0, y: -contentInset.top)
//        setContentOffset(topOffset, animated: animated)
//    }
//    
//    //    // Bonus: Scroll to bottom
//    //    func scrollToBottom() {
//    //        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
//    //        if(bottomOffset.y > 0) {
//    //            setContentOffset(bottomOffset, animated: true)
//    //        }
//    //    }
//    
//}
