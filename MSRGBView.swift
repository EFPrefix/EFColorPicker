//
//  MSRGBView.swift
//  EFColorPicker
//
//  Created by EyreFree on 2017/9/29.
//

import UIKit

public class MSRGBView: UIView, MSColorView {

    let MSColorSampleViewHeight: CGFloat = 30.0
    let MSViewMargin: CGFloat = 20.0
    let MSSliderViewMargin: CGFloat = 30.0
    let MSRGBColorComponentsSize: Int = 3

    private let colorSample: UIView = UIView()
    private var colorComponentViews: [UIControl] = []
    private var colorComponents: RGB = RGB(1, 1, 1, 1)

    weak public var delegate: MSColorViewDelegate?

    public var color: UIColor {
        get {
            return UIColor(
                red: colorComponents.red,
                green: colorComponents.green,
                blue: colorComponents.blue,
                alpha: colorComponents.alpha
            )
        }
        set {
            colorComponents = MSRGBColorComponents(color: newValue)
            self.reloadData()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.ms_baseInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.ms_baseInit()
    }

    func reloadData() {
        colorSample.backgroundColor = self.color
        colorSample.accessibilityValue = MSHexStringFromColor(color: self.color)
        self.ms_reloadColorComponentViews(colorComponents: colorComponents)
    }

    // MARK:- Private methods
    private func ms_baseInit() {
        self.accessibilityLabel = "rgb_view"

        colorSample.accessibilityLabel = "color_sample"
        colorSample.layer.borderColor = UIColor.black.cgColor
        colorSample.layer.borderWidth = 0.5
        colorSample.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(colorSample)

        var tmp: [UIControl] = []
        let titles = [
            NSLocalizedString("Red", comment: ""),
            NSLocalizedString("Green", comment: ""),
            NSLocalizedString("Blue", comment: "")
        ]
        let maxValues: [CGFloat] = [
            MSRGBColorComponentMaxValue, MSRGBColorComponentMaxValue, MSRGBColorComponentMaxValue
        ]
        for i in 0 ..< MSRGBColorComponentsSize {
            let colorComponentView = self.ms_colorComponentViewWithTitle(
                title: titles[i], tag: i, maxValue: maxValues[i]
            )
            self.addSubview(colorComponentView)
            colorComponentView.addTarget(
                self, action: #selector(ms_colorComponentDidChangeValue(_:)), for: UIControlEvents.valueChanged
            )
            tmp.append(colorComponentView)
        }

        colorComponentViews = tmp
        self.ms_installConstraints()
    }

    @objc @IBAction private func ms_colorComponentDidChangeValue(_ sender: MSColorComponentView) {
        self.ms_setColorComponentValue(value: sender.value / sender.maximumValue, atIndex: UInt(sender.tag))
        self.delegate?.colorView(colorView: self, didChangeColor: self.color)
        self.reloadData()
    }

    private func ms_setColorComponentValue(value: CGFloat, atIndex index: UInt) {
        switch index {
        case 0:
            colorComponents.red = value
            break
        case 1:
            colorComponents.green = value
            break
        case 2:
            colorComponents.blue = value
            break
        default:
            colorComponents.alpha = value
            break
        }
    }

    private func ms_colorComponentViewWithTitle(title: String, tag: Int, maxValue: CGFloat) -> UIControl {
        let colorComponentView: MSColorComponentView = MSColorComponentView()
        colorComponentView.title = title
        colorComponentView.translatesAutoresizingMaskIntoConstraints = false
        colorComponentView.tag = tag
        colorComponentView.maximumValue = maxValue
        return colorComponentView
    }

    private func ms_installConstraints() {
        let metrics = [
            "margin" : MSViewMargin,
            "height" : MSColorSampleViewHeight,
            "slider_margin" : MSSliderViewMargin
        ]
        var views = [
            "colorSample" : colorSample
        ]

        self.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-margin-[colorSample]-margin-|",
                options: NSLayoutFormatOptions(rawValue: 0),
                metrics: metrics,
                views: views
            )
        )
        self.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-margin-[colorSample(height)]",
                options: NSLayoutFormatOptions(rawValue: 0),
                metrics: metrics,
                views: views
            )
        )

        var previousView: UIView = colorSample
        for colorComponentView in colorComponentViews {
            views = [
                "previousView" : previousView,
                "colorComponentView" : colorComponentView
            ]
            self.addConstraints(
                NSLayoutConstraint.constraints(
                    withVisualFormat: "H:|-margin-[colorComponentView]-margin-|",
                    options: NSLayoutFormatOptions(rawValue: 0),
                    metrics: metrics,
                    views: views
                )
            )
            self.addConstraints(
                NSLayoutConstraint.constraints(
                    withVisualFormat: "V:[previousView]-slider_margin-[colorComponentView]",
                    options: NSLayoutFormatOptions(rawValue: 0),
                    metrics: metrics,
                    views: views
                )
            )
            previousView = colorComponentView
        }

        views = [
            "previousView" : previousView
        ]
        self.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:[previousView]-(>=margin)-|",
                options: NSLayoutFormatOptions(rawValue: 0),
                metrics: metrics,
                views: views
            )
        )
    }

    private func ms_colorComponentsWithRGB(rgb: RGB) -> [CGFloat] {
        return [rgb.red, rgb.green, rgb.blue, rgb.alpha]
    }

    private func ms_reloadColorComponentViews(colorComponents: RGB) {
        let components = self.ms_colorComponentsWithRGB(rgb: colorComponents)

        for (idx, colorComponentView) in colorComponentViews.enumerated() {
            if let colorComponentView = colorComponentView as? MSColorComponentView {
                colorComponentView.setColors(
                    colors: self.ms_colorsWithColorComponents(
                        colorComponents: components, currentColorIndex: colorComponentView.tag
                    )
                )
                colorComponentView.value = components[idx] * colorComponentView.maximumValue
            }
        }
    }

    private func ms_colorsWithColorComponents(colorComponents: [CGFloat], currentColorIndex colorIndex: Int) -> [CGColor] {
        let currentColorValue: CGFloat = colorComponents[colorIndex]
        var colors: [CGFloat] = [CGFloat](repeating: 0, count: 12)
        for i in 0 ..< MSRGBColorComponentsSize {
            colors[i] = colorComponents[i]
            colors[i + 4] = colorComponents[i]
            colors[i + 8] = colorComponents[i]
        }
        colors[colorIndex] = 0
        colors[colorIndex + 4] = currentColorValue
        colors[colorIndex + 8] = 1.0

        let start: UIColor = UIColor(red: colors[0], green: colors[1], blue: colors[2], alpha: 1)
        let middle: UIColor = UIColor(red: colors[4], green: colors[5], blue: colors[6], alpha: 1)
        let end: UIColor = UIColor(red: colors[8], green: colors[9], blue: colors[10], alpha: 1)

        return [start.cgColor, middle.cgColor, end.cgColor]
    }
}
