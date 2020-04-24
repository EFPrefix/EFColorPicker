//
//  EFColorWheelView.swift
//  EFColorPicker
//
//  Created by EyreFree on 2017/9/29.
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

import UIKit
import CoreGraphics

// The color wheel view.
public class EFColorWheelView: UIControl {
    
    public var isTouched = false
    var wheelImage: CGImage?

    // The hue value.
    public var hue: CGFloat = 0.0 {
        didSet {
            setSelectedPoint(point: ef_selectedPoint())
            setNeedsDisplay()
        }
    }

    // The saturation value.
    public var saturation: CGFloat = 0.0 {
        didSet {
            setSelectedPoint(point: ef_selectedPoint())
            setNeedsDisplay()
        }
    }

    // The saturation value.
    public var brightness: CGFloat = 1.0 {
        didSet {
            self.setSelectedPoint(point: ef_selectedPoint())
            if oldValue != brightness {
                drawWheelImage()
            }
        }
    }

    private lazy var indicatorLayer: CALayer = {
        let dimension: CGFloat = 33
        let edgeColor = UIColor(white: 0.9, alpha: 0.8)

        let indicatorLayer = CALayer()
        indicatorLayer.cornerRadius = dimension / 2
        indicatorLayer.borderColor = edgeColor.cgColor
        indicatorLayer.borderWidth = 2
        indicatorLayer.backgroundColor = UIColor.white.cgColor
        indicatorLayer.bounds = CGRect(x: 0, y: 0, width: dimension, height: dimension)
        indicatorLayer.position = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
        indicatorLayer.shadowColor = UIColor.black.cgColor
        indicatorLayer.shadowOffset = CGSize.zero
        indicatorLayer.shadowRadius = 1
        indicatorLayer.shadowOpacity = 0.5
        return indicatorLayer
    }()

    override open class var requiresConstraintBasedLayout: Bool {
        return true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        accessibilityLabel = "color_wheel_view"
        layer.delegate = self
        layer.addSublayer(indicatorLayer)

        // [self setSelectedPoint:CGPointMake(dimension / 2, dimension / 2)];
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouched = true
        if let position = touches.first?.location(in: self) {
            onTouchEventWithPosition(point: position)
        }
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let position = touches.first?.location(in: self) {
            onTouchEventWithPosition(point: position)
        }
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouched = false
        if let position = touches.first?.location(in: self) {
            onTouchEventWithPosition(point: position)
        }
    }
    
    func onTouchEventWithPosition(point: CGPoint) {
        let radius = self.bounds.width / 2

        let mx = Double(radius - point.x)
        let my = Double(radius - point.y)
        let dist = CGFloat(sqrt(mx * mx + my * my))

        if dist <= radius {
            ef_colorWheelValueWithPosition(position: point, hue: &hue, saturation: &saturation)
            setSelectedPoint(point: point)
            sendActions(for: .valueChanged)
        }
    }

    func setSelectedPoint(point: CGPoint) {
        let selectedColor = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)

        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        self.indicatorLayer.position = point
        self.indicatorLayer.backgroundColor = selectedColor.cgColor
        CATransaction.commit()
    }

    // MARK: - CALayerDelegate methods
    override public func display(_ layer: CALayer) {
        guard wheelImage == nil else { return }
        drawWheelImage()
    }

    override public func layoutSublayers(of layer: CALayer) {
        if layer == self.layer {
            self.setSelectedPoint(point: self.ef_selectedPoint())
            self.layer.setNeedsDisplay()
        }
    }

    // MARK: - Private methods
    private func drawWheelImage() {
        let dimension: CGFloat = min(self.frame.width, self.frame.height)
        guard let bitmapData = CFDataCreateMutable(nil, 0) else {
            return
        }

        CFDataSetLength(bitmapData, CFIndex(dimension * dimension * 4))
        self.ef_colorWheelBitmap(
            bitmap: CFDataGetMutableBytePtr(bitmapData),
            withSize: CGSize(width: dimension, height: dimension)
        )
        if let image = self.ef_imageWithRGBAData(data: bitmapData, width: Int(dimension), height: Int(dimension)) {
            wheelImage = image
            self.layer.contents = wheelImage
        }
    }

    private func ef_selectedPoint() -> CGPoint {
        let dimension = min(frame.width, frame.height)

        let radius = saturation * dimension / 2
        let x = dimension / 2 + radius * CGFloat(cos(Double(hue) * Double.pi * 2.0))
        let y = dimension / 2 + radius * CGFloat(sin(Double(hue) * Double.pi * 2.0))

        return CGPoint(x: x, y: y)
    }

    private func ef_colorWheelBitmap(bitmap: UnsafeMutablePointer<UInt8>?, withSize size: CGSize) {
        if size.width <= 0 || size.height <= 0 {
            return
        }

        for y in 0 ..< Int(size.width) {
            for x in 0 ..< Int(size.height) {
                var hue: CGFloat = 0, saturation: CGFloat = 0, a: CGFloat = 0.0
                ef_colorWheelValueWithPosition(position: CGPoint(x: x, y: y), hue: &hue, saturation: &saturation)

                var rgb = RGB(1, 1, 1, 1)
                if saturation < 1.0 {
                    // Antialias the edge of the circle.
                    if saturation > 0.99 {
                        a = (1.0 - saturation) * 100
                    } else {
                        a = 1.0
                    }

                    let hsb = HSB(hue, saturation, brightness, a)
                    rgb = EFHSB2RGB(hsb: hsb)
                }

                let i = 4 * (x + y * Int(size.width))
                bitmap?[i] = UInt8(rgb.red * 0xff)
                bitmap?[i + 1] = UInt8(rgb.green * 0xff)
                bitmap?[i + 2] = UInt8(rgb.blue * 0xff)
                bitmap?[i + 3] = UInt8(rgb.alpha * 0xff)
            }
        }
    }

    private func ef_colorWheelValueWithPosition(position: CGPoint, hue: inout CGFloat, saturation: inout CGFloat) {
        let c = Int(bounds.width / 2)
        let dx = (position.x - CGFloat(c)) / CGFloat(c)
        let dy = (position.y - CGFloat(c)) / CGFloat(c)
        let d = CGFloat(sqrt(Double(dx * dx + dy * dy)))

        saturation = d

        if d == 0 {
            hue = 0
        } else {
            hue = acos(dx / d) / CGFloat.pi / 2.0

            if dy < 0 {
                hue = 1.0 - hue
            }
        }
    }

    private func ef_imageWithRGBAData(data: CFData, width: Int, height: Int) -> CGImage? {
        guard let dataProvider = CGDataProvider(data: data) else {
            return nil
        }
        let colorSpace = CGColorSpaceCreateDeviceRGB()

        let imageRef = CGImage(
            width: width,
            height: height,
            bitsPerComponent: 8,
            bitsPerPixel: 32,
            bytesPerRow: width * 4,
            space: colorSpace,
            bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.last.rawValue),
            provider: dataProvider,
            decode: nil,
            shouldInterpolate: false,
            intent: CGColorRenderingIntent.defaultIntent
        )
        return imageRef
    }
}
