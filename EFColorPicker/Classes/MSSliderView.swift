//
//  MSSliderView.swift
//  EFColorPicker
//
//  Created by EyreFree on 2017/9/28.
//

import Foundation

public class MSSliderView: EFControl {

    let MSSliderViewHeight: CGFloat = 28.0
    let MSSliderViewMinWidth: CGFloat = 150.0
    let MSSliderViewTrackHeight: CGFloat = 3.0
    let MSThumbViewEdgeInset: CGFloat = -10.0

    private let thumbView: MSThumbView = MSThumbView()
    private let trackLayer: CAGradientLayer = CAGradientLayer()

    // The slider's current value. The default value is 0.0.
    private(set) var value: CGFloat = 0

    // The minimum value of the slider. The default value is 0.0.
    var minimumValue: CGFloat = 0

    // The maximum value of the slider. The default value is 1.0.
    var maximumValue: CGFloat = 1

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.accessibilityLabel = "color_slider"

        minimumValue = 0.0
        maximumValue = 1.0
        value = 0.0

        self.layer.delegate = self

        trackLayer.cornerRadius = MSSliderViewTrackHeight / 2.0
        trackLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        trackLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        self.layer.addSublayer(trackLayer)

        thumbView.hitTestEdgeInsets = UIEdgeInsets(
            top: MSThumbViewEdgeInset, left: MSThumbViewEdgeInset,
            bottom: MSThumbViewEdgeInset, right: MSThumbViewEdgeInset
        )
        thumbView.gestureRecognizer.addTarget(self, action: #selector(ms_didPanThumbView(gestureRecognizer:)))
        self.addSubview(thumbView)

        let color = UIColor.blue.cgColor
        self.setColors(colors: [color, color])
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open class var requiresConstraintBasedLayout: Bool {
        get {
            return true
        }
    }

    override public var intrinsicContentSize: CGSize {
        get {
            return CGSize(width: MSSliderViewMinWidth, height: MSSliderViewHeight)
        }
    }

    func setValue(value: CGFloat) {
        if (value < minimumValue) {
            self.value = minimumValue
        } else if (value > maximumValue) {
            self.value = maximumValue
        } else {
            self.value = value
        }

        self.ms_updateThumbPositionWithValue(value: self.value)
    }

    // Sets the array of CGColorRef objects defining the color of each gradient stop on the track.
    // The location of each gradient stop is evaluated with formula: i * width_of_the_track / number_of_colors.
    // @param colors An array of CGColorRef objects.
    func setColors(colors: [CGColor]) {
        if colors.count <= 1 {
            fatalError("‘colors: [CGColor]’ at least need to have 2 elements")
        }
        trackLayer.colors = colors
        self.ms_updateLocations()
    }

    override public func layoutSubviews() {
        self.ms_updateThumbPositionWithValue(value: self.value)
        self.ms_updateTrackLayer()
    }

    // MARK:- UIControl touch tracking events
    @objc func ms_didPanThumbView(gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state != UIGestureRecognizerState.began
            && gestureRecognizer.state != UIGestureRecognizerState.changed {
            return
        }

        let translation = gestureRecognizer.translation(in: self)
        gestureRecognizer.setTranslation(CGPoint.zero, in: self)

        self.ms_setValueWithTranslation(translation: translation.x)
    }

    func ms_updateTrackLayer() {
        let height: CGFloat = MSSliderViewHeight
        let width: CGFloat = self.bounds.width

        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        trackLayer.bounds = CGRect(x: 0, y: 0, width: width, height: MSSliderViewTrackHeight)
        trackLayer.position = CGPoint(x: self.bounds.width / 2, y: height / 2)
        CATransaction.commit()
    }

    // MARK:- Private methods
    private func ms_setValueWithTranslation(translation: CGFloat) {
        let width: CGFloat = self.bounds.width - thumbView.bounds.width
        let valueRange: CGFloat = maximumValue - minimumValue
        let value: CGFloat = self.value + valueRange * translation / width

        self.setValue(value: value)
        self.sendActions(for: UIControlEvents.valueChanged)
    }

    private func ms_updateLocations() {
        let size: Int = trackLayer.colors?.count ?? 2
        if size == trackLayer.locations?.count {
            return
        }

        let step: CGFloat = 1.0 / (CGFloat(size) - 1)
        var locations: [NSNumber] = [0]

        var i: Int = 1
        while i < size - 1 {
            locations.append(NSNumber(value: Double(CGFloat(i) * step)))
            i += 1
        }

        locations.append(1.0)
        trackLayer.locations = locations
    }

    private func ms_updateThumbPositionWithValue(value: CGFloat) {
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
