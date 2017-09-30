//
//  EFThumbView.swift
//  EFColorPicker
//
//  Created by EyreFree on 2017/9/28.
//

import UIKit

public class EFThumbView: EFControl {

    private(set) var gestureRecognizer: UIGestureRecognizer = UIPanGestureRecognizer(target: nil, action: nil)

    private let EFSliderViewThumbDimension: CGFloat = 28.0
    private let thumbLayer: CALayer = CALayer()

    override init(frame: CGRect) {
        super.init(
            frame: CGRect(
                x: frame.origin.x, y: frame.origin.y,
                width: EFSliderViewThumbDimension, height: EFSliderViewThumbDimension
            )
        )

        self.thumbLayer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
        self.thumbLayer.borderWidth = 0.5
        self.thumbLayer.cornerRadius = EFSliderViewThumbDimension / 2
        self.thumbLayer.backgroundColor = UIColor.white.cgColor
        self.thumbLayer.shadowColor = UIColor.black.cgColor
        self.thumbLayer.shadowOffset = CGSize(width: 0, height: 3)
        self.thumbLayer.shadowRadius = 2
        self.thumbLayer.shadowOpacity = 0.3
        self.layer.addSublayer(self.thumbLayer)

        self.addGestureRecognizer(self.gestureRecognizer)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func layoutSublayers(of layer: CALayer) {
        if layer != self.layer {
            return
        }

        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        self.thumbLayer.bounds = CGRect(
            x: 0, y: 0, width: EFSliderViewThumbDimension, height: EFSliderViewThumbDimension
        )
        self.thumbLayer.position = CGPoint(x: EFSliderViewThumbDimension / 2, y: EFSliderViewThumbDimension / 2)
        CATransaction.commit()
    }
}
