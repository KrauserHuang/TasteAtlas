//
//  UIView.swift
//  TasteAtlas
//
//  Created by Tai Chin Huang on 2024/12/8.
//

import UIKit

extension UIView {
    /// Create a view using auto layout
    /// - Parameter useAutoLayout: A bool value that determines if the view should use auto layout
    convenience init(useAutoLayout: Bool) {
        self.init()
        translatesAutoresizingMaskIntoConstraints = !useAutoLayout
    }
    
    func pinToSuperview(with insets: UIEdgeInsets = .zero, edges: UIRectEdge = .all) {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        if edges.contains(.top) { topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top).isActive = true }
        if edges.contains(.bottom) { bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom).isActive = true }
        if edges.contains(.left) { leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left).isActive = true }
        if edges.contains(.right) { trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -insets.right).isActive = true }
    }
    
    func roundedView(corners: UIRectCorner = .allCorners, radius: CGFloat) {
        let maskPath1 = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    
    func asImage(frame: CGRect? = nil, scale: CGFloat = UIScreen.main.scale) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(frame?.size ?? bounds.size, false, scale)
        drawHierarchy(in: bounds, afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

// MARK: - ReuseIdentifiable
extension UIView: ReuseIdentifiable {}
