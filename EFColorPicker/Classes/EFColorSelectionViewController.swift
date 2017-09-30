//
//  EFColorSelectionViewController.swift
//  EFColorPicker
//
//  Created by EyreFree on 2017/9/29.
//

import UIKit

// The delegate of a EFColorSelectionViewController object must adopt the EFColorSelectionViewController protocol.
// Methods of the protocol allow the delegate to handle color value changes.
public protocol EFColorSelectionViewControllerDelegate: class {

    // Tells the data source to return the color components.
    // @param colorViewCntroller The color view.
    // @param color The new color value.
    func colorViewController(colorViewCntroller: EFColorSelectionViewController, didChangeColor color: UIColor)
}

public class EFColorSelectionViewController: UIViewController, EFColorViewDelegate {

    // The controller's delegate. Controller notifies a delegate on color change.
    public weak var delegate: EFColorSelectionViewControllerDelegate?

    // The current color value.
    public var color: UIColor {
        get {
            return self.colorSelectionView().color
        }
        set {
            self.colorSelectionView().color = newValue
        }
    }

    override public func loadView() {
        let colorSelectionView: EFColorSelectionView = EFColorSelectionView(frame: UIScreen.main.bounds)
        self.view = colorSelectionView
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        let segmentControl: UISegmentedControl = UISegmentedControl(
            items: [NSLocalizedString("RGB", comment: ""), NSLocalizedString("HSB", comment: "")]
        )
        segmentControl.addTarget(
            self,
            action: #selector(segmentControlDidChangeValue(_:)),
            for: UIControlEvents.valueChanged
        )
        segmentControl.selectedSegmentIndex = 0
        self.navigationItem.titleView = segmentControl

        self.colorSelectionView().setSelectedIndex(index: EFSelectedColorView.RGB, animated: false)
        self.colorSelectionView().delegate = self
        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0)
    }

    @IBAction func segmentControlDidChangeValue(_ segmentedControl: UISegmentedControl) {
        self.colorSelectionView().setSelectedIndex(
            index: EFSelectedColorView(rawValue: segmentedControl.selectedSegmentIndex) ?? EFSelectedColorView.RGB,
            animated: true
        )
    }

    override public func viewWillLayoutSubviews() {
        self.colorSelectionView().setNeedsUpdateConstraints()
        self.colorSelectionView().updateConstraintsIfNeeded()
    }

    func colorSelectionView() -> EFColorSelectionView {
        return self.view as? EFColorSelectionView ?? EFColorSelectionView()
    }

    // MARK:- EFColorViewDelegate
    public func colorView(colorView: EFColorView, didChangeColor color: UIColor) {
        self.delegate?.colorViewController(colorViewCntroller: self, didChangeColor: color)
    }
}

