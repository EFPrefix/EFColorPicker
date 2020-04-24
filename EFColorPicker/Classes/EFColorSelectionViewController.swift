//
//  EFColorSelectionViewController.swift
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

public enum EFColorSelectionMode: Int {
    case all = 0
    case rgb = 1
    case hsb = 2
}

// The delegate of a EFColorSelectionViewController object must adopt the EFColorSelectionViewController protocol.
// Methods of the protocol allow the delegate to handle color value changes.
@objc public protocol EFColorSelectionViewControllerDelegate: NSObjectProtocol {

    // Tells the data source to return the color components.
    // @param colorViewCntroller The color view.
    // @param color The new color value.
    func colorViewController(_ colorViewCntroller: EFColorSelectionViewController, didChangeColor color: UIColor)
}

public class EFColorSelectionViewController: UIViewController {

    // The controller's delegate. Controller notifies a delegate on color change.
    public weak var delegate: EFColorSelectionViewControllerDelegate?
    
    // The current color value.
    public var color: UIColor {
        get {
            return colorSelectionView.color
        }
        set {
            colorSelectionView.color = newValue
        }
    }
    let colorSelectionView = EFColorSelectionView(frame: UIScreen.main.bounds)
    let segmentControl = UISegmentedControl(items: [NSLocalizedString("RGB", comment: ""), NSLocalizedString("HSB", comment: "")])
    // Whether colorTextField will hide, default is `true`
    public var isColorTextFieldHidden: Bool {
        get {
            return !colorSelectionView.hsbColorView.brightnessView.colorTextFieldEnabled
        }
        set {
            if colorSelectionView.hsbColorView.brightnessView.colorTextFieldEnabled == newValue {
                colorSelectionView.hsbColorView.brightnessView.colorTextFieldEnabled = !newValue
                for colorComponentView in colorSelectionView.rgbColorView.colorComponentViews {
                    colorComponentView.colorTextFieldEnabled = !newValue
                }
            }
        }
    }
    override public func loadView() {
        self.view = colorSelectionView
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        segmentControl.addTarget(
            self,
            action: #selector(segmentControlDidChangeValue(_:)),
            for: .valueChanged
        )
        segmentControl.selectedSegmentIndex = 0
        navigationItem.titleView = segmentControl

        colorSelectionView.setSelectedIndex(index: .RGB, animated: false)
        colorSelectionView.delegate = self
        edgesForExtendedLayout = UIRectEdge(rawValue: 0)
    }

    public func setMode(mode: EFColorSelectionMode) {
        switch mode {
        case .rgb:
            segmentControl.isHidden = true
            segmentControl.selectedSegmentIndex = 0
            colorSelectionView.setSelectedIndex(index: .RGB, animated: false)
        case .hsb:
            segmentControl.isHidden = true
            segmentControl.selectedSegmentIndex = 1
            colorSelectionView.setSelectedIndex(index: .HSB, animated: false)
        default:
            segmentControl.isHidden = false
        }
    }

    @IBAction func segmentControlDidChangeValue(_ segmentedControl: UISegmentedControl) {
        colorSelectionView.setSelectedIndex(
            index: EFSelectedColorView(rawValue: segmentedControl.selectedSegmentIndex) ?? .RGB,
            animated: true
        )
    }

    override public func viewWillLayoutSubviews() {
        colorSelectionView.setNeedsUpdateConstraints()
        colorSelectionView.updateConstraintsIfNeeded()
    }
}
extension EFColorSelectionViewController: EFColorViewDelegate {
    public func colorView(_ colorView: EFColorView, didChangeColor color: UIColor) {
        delegate?.colorViewController(self, didChangeColor: color)
    }
}
