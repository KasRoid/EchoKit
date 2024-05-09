//
//  UIView+Extensions.swift
//
//
//  Created by Lukas on 4/19/24.
//

import UIKit

internal extension UIView {
    
    @discardableResult
    func setupWithXib() -> UIView? {
        guard let view = bundle.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? UIView else {
            print("Error: Could not load the XIB for \(String(describing: type(of: self)))")
            return nil
        }
        view.frame = bounds
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        guard let superview = view.superview else {
            print("Error: Could not find superview for \(String(describing: type(of: self)))")
            return view
        }
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: superview.topAnchor),
            view.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: superview.trailingAnchor)
        ])
        return view
    }
    
    var width: CGFloat {
        get {
            frame.size.width
        }
        set {
            var newFrame: CGRect = frame
            newFrame.size.width = newValue
            frame = newFrame
        }
    }
    
    var height: CGFloat {
        get {
            frame.size.height
        }
        set {
            var newFrame: CGRect = frame
            newFrame.size.height = newValue
            frame = newFrame
        }
    }
    
    var asImage: UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    
    static var screenWidth: CGFloat {
        UIScreen.main.bounds.size.width
    }
    
    static var screenHeight: CGFloat {
        UIScreen.main.bounds.size.height
    }
    
    static var safeScreenHeight: CGFloat {
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        let topInset = window?.safeAreaInsets.top ?? 0
        let bottomInset = window?.safeAreaInsets.bottom ?? 0
        return UIScreen.main.bounds.height - (topInset + bottomInset)
    }
    
    static var defaultConsoleHeight: CGFloat {
        screenHeight / 3
    }
}
