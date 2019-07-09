//
//  GDCheckbox.swift
//  CheckBox
//
//  Created by Saeidbsn on 1/12/17.
//  Copyright © 2017 Saeidbsn. All rights reserved.
//  saeidbsn.com

import Foundation
import UIKit

@IBDesignable
open class SRCheckbox: UIControl {
// MARK: - Variables

    @IBInspectable
    open var containerWidth: CGFloat = 2.0 {
        didSet { setNeedsLayout() }
    }
    
    @IBInspectable
    open var containerColor: UIColor = UIColor.black {
        didSet { setNeedsLayout() }
    }
    
    @IBInspectable
    open var checkWidth: CGFloat = 3.0 {
        didSet { setNeedsLayout() }
    }
    
    @IBInspectable
    open var checkColor: UIColor = UIColor.black {
        didSet { drawCheckmark() }
    }
    
    @IBInspectable
    open var shouldFillContainer: Bool = false {
        didSet { drawCheckmark() }
    }
    
    @IBInspectable
    open var shouldAnimate: Bool = false
    
    @IBInspectable
    open var isOn: Bool = false{
        didSet { drawCheckmark() }
    }
    
    @IBInspectable
    open var isSquare: Bool = false {
        didSet { setNeedsLayout() }
    }
    
    @IBInspectable
    open var isRadiobox: Bool = false {
        didSet { setNeedsLayout() }
    }
    
    @IBInspectable
    open var isCircular: Bool = false{
        didSet { setNeedsLayout() }
    }
    
    fileprivate var containerLayer = CAShapeLayer()
    fileprivate var checkmarkLayer = CAShapeLayer()
    
    fileprivate var containerFrame: CGRect {
        let width = bounds.width
        let height = bounds.height
        
        let x: CGFloat
        let y: CGFloat
        
        let eqLength: CGFloat
        
        if width > height{
            eqLength = height
            x = (width - eqLength) / 2
            y = 0
        }else{
            eqLength = width
            x = 0
            y = (height - eqLength) / 2
        }
        
        let halfContainerWidth = containerWidth / 2
        return CGRect(x: x + halfContainerWidth, y: y + halfContainerWidth, width: eqLength - halfContainerWidth, height: eqLength - halfContainerWidth)
    }
    
    fileprivate var containerPath: UIBezierPath {
        if isRadiobox || isCircular {
            return UIBezierPath(ovalIn: containerFrame)
        }else{
            return UIBezierPath(rect: containerFrame)
        }
    }
    
    fileprivate var checkPath: UIBezierPath {
        let containerFrame = self.containerFrame
        
        let inset = containerWidth / 2
        let checkFrame = containerFrame.insetBy(dx: inset, dy: inset)
        
        let path = UIBezierPath()
        let origin = checkFrame.origin
        let x = origin.x
        let y = origin.y
        
        if isSquare {
            let unit = checkFrame.width / 4
            
            path.move(to: CGPoint(x: x + unit, y: y + unit))
            path.addLine(to: CGPoint(x: x + unit, y: y + (3 * unit)))
            path.addLine(to: CGPoint(x: x + (3 * unit), y: y + (3 * unit)))
            path.addLine(to: CGPoint(x: x + (3 * unit), y: y + unit))
            path.addLine(to: CGPoint(x: x +  unit, y: y + unit))
            path.close()
        } else if isRadiobox {
            let unit = checkFrame.width / 4
            
            path.addArc(withCenter: CGPoint(x: x + (2 * unit), y: y + (2 * unit)), radius: containerFrame.width / 3 - checkWidth, startAngle: 0.0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        } else {
            let unit = checkFrame.width / 33
            
            path.move(to: CGPoint(x: x + (7 * unit), y: y + (18 * unit)))
            path.addLine(to: CGPoint(x: x + (14 * unit), y: y + (25 * unit)))
            path.addLine(to: CGPoint(x: x + (27 * unit), y: y + (10 * unit)))
        }
        
        return path
    }
    
// MARK: - Methods
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeCheckbox()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initializeCheckbox()
    }
    
    fileprivate func initializeCheckbox() {
        checkmarkLayer.fillColor = UIColor.clear.cgColor
        updateLayers()
        drawCheckmark()
        layer.addSublayer(containerLayer)
        layer.addSublayer(checkmarkLayer)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        updateLayers()
    }
    
    fileprivate func updateLayers() {
        containerLayer.frame = bounds
        containerLayer.lineWidth = containerWidth
        containerLayer.path = containerPath.cgPath
        
        checkmarkLayer.frame = bounds
        checkmarkLayer.lineWidth = checkWidth
        checkmarkLayer.path = checkPath.cgPath
        checkmarkLayer.lineJoin = CAShapeLayerLineJoin.round
    }
    
    fileprivate func drawCheckmark() {
        DispatchQueue.main.async {
            self.containerLayer.strokeColor = self.containerColor.cgColor
            
            if self.isOn {
                self.containerLayer.fillColor = self.shouldFillContainer ? self.containerColor.cgColor : UIColor.clear.cgColor
                
                if self.shouldAnimate && !self.isRadiobox && !self.isSquare {
                    self.checkmarkLayer.strokeColor = self.checkColor.cgColor
                    
                    let anim = CABasicAnimation(keyPath: "strokeEnd")
                    anim.duration = 0.2
                    anim.fromValue = 0.0
                    anim.toValue = 1.0
                    
                    self.checkmarkLayer.add(anim, forKey: "stroke")
                } else {
                    if self.isSquare {
                        self.checkmarkLayer.fillColor = self.checkColor.cgColor
                    } else if self.isRadiobox {
                        self.checkmarkLayer.fillColor = self.checkColor.cgColor
                    } else {
                        self.checkmarkLayer.strokeColor = self.checkColor.cgColor
                    }
                }
            } else {
                self.containerLayer.fillColor = UIColor.clear.cgColor
                
                if self.isSquare {
                    self.checkmarkLayer.fillColor = UIColor.clear.cgColor
                } else if self.isRadiobox {
                    self.checkmarkLayer.fillColor = UIColor.clear.cgColor
                } else {
                    self.checkmarkLayer.strokeColor = UIColor.clear.cgColor
                }
            }
            
            self.setNeedsDisplay()
        }
    }
    
    open override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        isOn = !isOn
        sendActions(for: [.valueChanged])
        return true
    }
}

