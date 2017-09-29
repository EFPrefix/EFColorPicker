//
//  MSColorSelectionViewController.swift
//  EFColorPicker
//
//  Created by EyreFree on 2017/9/29.
//

import UIKit

// The delegate of a MSColorSelectionViewController object must adopt the MSColorSelectionViewController protocol.
// Methods of the protocol allow the delegate to handle color value changes.
public protocol MSColorSelectionViewControllerDelegate: class {

    // Tells the data source to return the color components.
    // @param colorViewCntroller The color view.
    // @param color The new color value.
    func colorViewController(colorViewCntroller: MSColorSelectionViewController, didChangeColor color: UIColor)
}

public class MSColorSelectionViewController: UIViewController, MSColorViewDelegate {

    // The controller's delegate. Controller notifies a delegate on color change.
    public weak var delegate: MSColorSelectionViewControllerDelegate?

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
        let colorSelectionView: MSColorSelectionView = MSColorSelectionView(frame: UIScreen.main.bounds)
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

        self.colorSelectionView().setSelectedIndex(index: MSSelectedColorView.RGB, animated: false)
        self.colorSelectionView().delegate = self
        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0)
    }

    @IBAction func segmentControlDidChangeValue(_ segmentedControl: UISegmentedControl) {
        self.colorSelectionView().setSelectedIndex(
            index: MSSelectedColorView(rawValue: segmentedControl.selectedSegmentIndex) ?? MSSelectedColorView.RGB,
            animated: true
        )
    }

    override public func viewWillLayoutSubviews() {
        self.colorSelectionView().setNeedsUpdateConstraints()
        self.colorSelectionView().updateConstraintsIfNeeded()
    }

    func colorSelectionView() -> MSColorSelectionView {
        return self.view as? MSColorSelectionView ?? MSColorSelectionView()
    }

    // MARK:- MSColorViewDelegate
    public func colorView(colorView: MSColorView, didChangeColor color: UIColor) {
        self.delegate?.colorViewController(colorViewCntroller: self, didChangeColor: color)
    }
}

