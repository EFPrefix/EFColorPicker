//
//  EFSliderView.swift
//  EFColorPicker
//
//  Created by EyreFree on 2017/9/28.
//
//  Copyright (c) 2017 EyreFree <eyrefree@eyrefree.org>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation
import CoreGraphics
import QuartzCore
import UIKit

public class EFSliderView: EFControl {
    
    let EFSliderViewHeight: CGFloat = 28.0
    let EFSliderViewMinWidth: CGFloat = 150.0
    let EFSliderViewTrackHeight: CGFloat = 6.0
    let EFThumbViewEdgeInset: CGFloat = -10.0
    
    private lazy var thumbView: EFThumbView = {
        let thumb = EFThumbView()
        thumb.hitTestEdgeInsets = UIEdgeInsets(
            top: EFThumbViewEdgeInset, left: EFThumbViewEdgeInset,
            bottom: EFThumbViewEdgeInset, right: EFThumbViewEdgeInset
        )
        thumb.gestureRecognizer.addTarget(self, action: #selector(ef_didPanThumbView(gestureRecognizer:)))
        return thumb
    }()
    private lazy var trackLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.cornerRadius = EFSliderViewTrackHeight / 2.0
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        return gradient
    }()
    
    // The slider's current value. The default value is 0.0.
    public private(set) var value: CGFloat = 0
    
    // The minimum value of the slider. The default value is 0.0.
    public var minimumValue: CGFloat = 0
    
    // The maximum value of the slider. The default value is 1.0.
    public var maximumValue: CGFloat = 1
    
    // Indicates if the user touches the control at the moment
    public var isTouched = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        accessibilityLabel = "color_slider"
        layer.delegate = self
        layer.addSublayer(trackLayer)
        addSubview(thumbView)
        setColors(colors: [.blue, .blue])
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open class var requiresConstraintBasedLayout: Bool {
        return true
    }
    
    override public var intrinsicContentSize: CGSize {
        return CGSize(width: EFSliderViewMinWidth, height: EFSliderViewHeight)
    }
    
    func setValue(value: CGFloat) {
        self.value = min(maximumValue, max(value, minimumValue))
        self.ef_updateThumbPositionWithValue(value: self.value)
    }
    
    // Sets the array of CGColorRef objects defining the color of each gradient stop on the track.
    // The location of each gradient stop is evaluated with formula: i * width_of_the_track / number_of_colors.
    // @param colors An array of CGColorRef objects.
    func setColors(colors: [UIColor]) {
        let cgColors = colors.map {$0.cgColor}
        if cgColors.count <= 1 {
            fatalError("‘colors: [CGColor]’ at least need to have 2 elements")
        }
        trackLayer.colors = cgColors
        self.ef_updateLocations()
    }
    override public func layoutSubviews() {
        self.ef_updateThumbPositionWithValue(value: self.value)
        self.ef_updateTrackLayer()
    }
    // MARK: - UIControl touch tracking events
    @objc func ef_didPanThumbView(gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizer.State.ended {
            self.isTouched = false
        } else if gestureRecognizer.state == UIGestureRecognizer.State.began {
            self.isTouched = true
        }
        
        if gestureRecognizer.state != UIGestureRecognizer.State.began
            && gestureRecognizer.state != UIGestureRecognizer.State.changed {
            return
        }
        
        let translation = gestureRecognizer.translation(in: self)
        gestureRecognizer.setTranslation(CGPoint.zero, in: self)
        
        self.ef_setValueWithTranslation(translation: translation.x)
    }
    
    func ef_updateTrackLayer() {
        let height: CGFloat = EFSliderViewHeight
        let width: CGFloat = self.bounds.width
        
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        trackLayer.bounds = CGRect(x: 0, y: 0, width: width, height: EFSliderViewTrackHeight)
        trackLayer.position = CGPoint(x: self.bounds.width / 2, y: height / 2)
        CATransaction.commit()
    }
    // MARK: - Private methods
    private func ef_setValueWithTranslation(translation: CGFloat) {
        let width: CGFloat = self.bounds.width - thumbView.bounds.width
        let valueRange: CGFloat = maximumValue - minimumValue
        let value: CGFloat = self.value + valueRange * translation / width
        
        self.setValue(value: value)
        self.sendActions(for: UIControl.Event.valueChanged)
    }
    
    private func ef_updateLocations() {
        let size: Int = trackLayer.colors?.count ?? 2
        if size == trackLayer.locations?.count {
            return
        }
        
        let step = 1.0 / CGFloat(size - 1)
        var locations: [NSNumber] = [0]
        
        var i: Int = 1
        while i < size - 1 {
            locations.append(NSNumber(value: Double(CGFloat(i) * step)))
            i += 1
        }
        
        locations.append(1.0)
        trackLayer.locations = locations
    }
    
    private func ef_updateThumbPositionWithValue(value: CGFloat) {
        let thumbWidth: CGFloat = thumbView.bounds.width
        let thumbHeight: CGFloat = thumbView.bounds.height
        let width: CGFloat = self.bounds.width - thumbWidth
        
        if width == 0 {
            return
        }
        
        let percentage: CGFloat = (value - minimumValue) / (maximumValue - minimumValue)
        let position: CGFloat = width * percentage
        thumbView.frame = CGRect(x: position, y: 0, width: thumbWidth, height: thumbHeight)
    }
}
