//
//  UIView+Extensions.swift
//  BunYankm
//
//  Created by hady on 21/04/2022.
//

import UIKit

extension UIView{
    
    func addShadowWith(color: UIColor, radius: CGFloat, opacity: Float?) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity ?? 0.7
    }
    
    func addNormalShadow(){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.2
        
    }
    
    func addCornerRadius(_ radius: CGFloat = 0) {
        if radius == 0 {
            self.layer.cornerRadius = self.frame.size.height / 2
        } else {
            self.layer.cornerRadius = radius
        }
    }
    
    func addBorderWith(width: CGFloat, color: UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    func addDashedCircle(strokeColor: CGColor = UIColor.blue.cgColor, lineWidth: CGFloat = 3.0, isCircle: Bool = true) {
        let circleLayer = CAShapeLayer()
        if isCircle {
            circleLayer.path = UIBezierPath(ovalIn: bounds).cgPath
        } else {
            circleLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 5).cgPath
        }
        circleLayer.lineWidth = lineWidth
        circleLayer.strokeColor = strokeColor //border of circle
        circleLayer.fillColor = UIColor.clear.cgColor //inside the circle
        circleLayer.lineJoin = .round
        circleLayer.lineDashPattern = [6,3]
        layer.addSublayer(circleLayer)
    }
    
    func roundedFromSide(corners: UIRectCorner, cornerRadius: Double) {
        
        let size = CGSize(width: cornerRadius, height: cornerRadius)
        let bezierPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: size)
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = self.bounds
        shapeLayer.path = bezierPath.cgPath
        self.layer.mask = shapeLayer
    }
    
    func rounded(borderWidth: CGFloat, cornerRadius: CGFloat, borderColor: UIColor) {
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        self.layer.borderColor = borderColor.cgColor
    }
    
    func shadow( shadowOpacity: Float? = 0.1, color: CGColor? = UIColor.init(named: "000000")?.withAlphaComponent(0.9).cgColor) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color
        self.layer.shadowOffset = CGSize.zero //CGSize(width: -1, height: 1)
        self.layer.shadowOpacity = shadowOpacity ?? 0.1
    }
    
    func shadowWithCorner(shadowOpacity: Float? = 0.1, color: CGColor? = UIColor.init(named: "000000")?.withAlphaComponent(0.9).cgColor) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowOpacity = shadowOpacity ?? 0.1
        self.layer.cornerRadius = 8
        //        self.layer.masksToBounds = true
        
    }
    
    func dropShdow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1.0)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 8.0
        layer.masksToBounds = false
    }
    
    func setBorder( color: CGColor? = UIColor.lightGray.cgColor.copy(alpha: 0.5), width: CGFloat? = 0.5) {
        self.layer.borderColor = color ?? UIColor.lightGray.cgColor.copy(alpha: 0.5)
        self.layer.borderWidth = width ?? 0.5
    }
    
    func cornerRadiusView( radius: CGFloat? = nil) {
        self.layer.cornerRadius = radius ?? self.frame.width / 2
        self.layer.masksToBounds = true
    }
    
    func cornerRadiusForHeight() {
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = true
    }
    
    func cornerRadiusForHeight_(cornerRadius: Float) {
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.layer.masksToBounds = true
    }
    
    func applyGradient(colours: [UIColor], locations: [NSNumber]?, corner: CGFloat = 0.0) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.cornerRadius = corner
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func setGradient(corner: CGFloat = 0.0) {
        let firstColor = UIColor(displayP3Red: 73/255, green: 125/255, blue: 0/255, alpha: 1)
        let secondColor = UIColor(displayP3Red: 134/255, green: 209/255, blue: 28/255, alpha: 1)
        self.applyGradient(colours: [ firstColor, secondColor], locations: [0.0, 1.0], corner: corner)
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
}

public protocol NibDesignableProtocol: NSObjectProtocol {
    /**
     Identifies the view that will be the superview of the contents loaded from
     the Nib. Referenced in setupNib().
     
     - returns: Superview for Nib contents.
     */
    var nibContainerView: UIView { get }
    // MARK: - Nib loading
    
    /**
     Called to load the nib in setupNib().
     
     - returns: UIView instance loaded from a nib file.
     */
    func loadNib() -> UIView
    /**
     Called in the default implementation of loadNib(). Default is class name.
     
     - returns: Name of a single view nib file.
     */
    func nibName() -> String
}

extension NibDesignableProtocol {
    // MARK: - Nib loading
    
    /**
     Called to load the nib in setupNib().
     
     - returns: UIView instance loaded from a nib file.
     */
    public func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.nibName(), bundle: bundle)
        
        guard let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView else {
            return UIView()
        }
        return view
    }
    
    // MARK: - Nib loading
    
    /**
     Called in init(frame:) and init(aDecoder:) to load the nib and add it as a subview.
     */
    func setupNib() {
        let view = self.loadNib()
        self.nibContainerView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        let bindings = ["view": view]
        self.nibContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: nil, views: bindings))
        self.nibContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: [], metrics: nil, views: bindings))
    }
}

extension UIView {
    public var nibContainerView: UIView {
        return self
    }
    /**
     Called in the default implementation of loadNib(). Default is class name.
     
     - returns: Name of a single view nib file.
     */
    @objc open func nibName() -> String {
        return type(of: self).description().components(separatedBy: ".").last!
    }
    
    public func addSubviewAndPinToEdges(_ view: UIView, constants: UIEdgeInsets = .zero, respectsLanguage: Bool = true) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        pinToEdges(view: view, constants: constants, respectsLanguage: respectsLanguage)
    }
    
    public func pinToEdges(view: UIView, constants: UIEdgeInsets = .zero, respectsLanguage: Bool = true) {
        let constraints: [NSLayoutConstraint]
        constraints = [
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: constants.right),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: constants.bottom),
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: constants.left),
            view.topAnchor.constraint(equalTo: topAnchor, constant: constants.top)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

open class NibDesignable: UIView, NibDesignableProtocol {
    // MARK: - Initializer
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupNib()
    }
    
    // MARK: - NSCoding
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupNib()
    }
}

extension UIView {
    public class var nibName: String {
        return String(describing: self)
    }
    
    @discardableResult
    public func loadNib() -> UIView? {
        let nibName = type(of: self).nibName
        return Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?.first as? UIView
    }
    
    public func loadViewFromNib(nibName: String) -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(
            withOwner: self,
            options: nil).first as? UIView
    }
}
