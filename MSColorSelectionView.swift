//
//  MSColorSelectionView.swift
//  EFColorPicker
//
//  Created by EyreFree on 2017/9/29.
//

import Foundation

// The enum to define the MSColorView's types.
enum MSSelectedColorView: Int {
    // The RGB color view type.
    case RGB = 0

    // The HSB color view type.
    case HSB = 1
}

// The MSColorSelectionView aggregates views that should be used to edit color components.
class MSColorSelectionView: UIView, MSColorView, MSColorViewDelegate {

    // The selected color view
    private(set) var selectedIndex: MSSelectedColorView = MSSelectedColorView.RGB

    private let rgbColorView: UIView = MSRGBView()
    private let hsbColorView: UIView = MSHSBView()

    weak var delegate: MSColorViewDelegate?

    var color: UIColor = UIColor.clear {
        didSet {
            self.selectedView()?.color = color
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.ms_init()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.ms_init()
    }

    // Makes a color component view (rgb or hsb) visible according to the index.
    // @param index    This index define a view to show.
    // @param animated If YES, the view is being appeared using an animation.
    func setSelectedIndex(index: MSSelectedColorView, animated: Bool) {
        self.selectedIndex = index
        self.selectedView()?.color = self.color
        UIView.animate(withDuration: animated ? 0.5 : 0.0) {
            [weak self] in
            if let strongSelf = self {
                strongSelf.rgbColorView.alpha = MSSelectedColorView.RGB == index ? 1.0 : 0.0
                strongSelf.hsbColorView.alpha = MSSelectedColorView.RGB == index ? 1.0 : 0.0
            }
        }
    }

    func selectedView() -> MSColorView? {
        return (MSSelectedColorView.RGB == self.selectedIndex ? self.rgbColorView : self.hsbColorView) as? MSColorView
    }

    func addColorView(view: MSColorView) {
        view.delegate = self
        if let view = view as? UIView {
            self.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            let views = [
                "view" : view
            ]
            self.addConstraints(
                NSLayoutConstraint.constraints(
                    withVisualFormat: "H:|[view]|",
                    options: NSLayoutFormatOptions(rawValue: 0),
                    metrics: nil,
                    views: views
                )
            )
            self.addConstraints(
                NSLayoutConstraint.constraints(
                    withVisualFormat: "V:|[view]|",
                    options: NSLayoutFormatOptions(rawValue: 0),
                    metrics: nil,
                    views: views
                )
            )
        }
    }

    override func updateConstraints() {
        self.rgbColorView.setNeedsUpdateConstraints()
        self.hsbColorView.setNeedsUpdateConstraints()
        super.updateConstraints()
    }

    // MARK:- FBColorViewDelegate methods
    func colorView(colorView: MSColorView, didChangeColor color: UIColor) {
        self.color = color
        self.delegate?.colorView(colorView: self, didChangeColor: self.color)
    }

    // MARK:- Private
    private func ms_init() {
        self.accessibilityLabel = "color_selection_view"

        self.backgroundColor = UIColor.white
        if let rgbColorView = self.rgbColorView as? MSColorView, let hsbColorView = self.hsbColorView as? MSColorView {
            self.addColorView(view: rgbColorView)
            self.addColorView(view: hsbColorView)
        }
        self.setSelectedIndex(index: MSSelectedColorView.RGB, animated: false)
    }
}
