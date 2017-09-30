//
//  EFColorView.swift
//  EFColorPicker
//
//  Created by EyreFree on 2017/9/28.
//

import UIKit

//  The delegate of a EFColorView object must adopt the EFColorViewDelegate protocol.
//  Methods of the protocol allow the delegate to handle color value changes.
public protocol EFColorViewDelegate: class {

    // Tells the data source to return the color components.
    // @param colorView The color view.
    // @param color The new color value.
    func colorView(colorView: EFColorView, didChangeColor color: UIColor)
}

/// The \c EFColorView protocol declares a view's interface for displaying and editing color value.
public protocol EFColorView: class {

    // The object that acts as the delegate of the receiving color selection view.
    weak var delegate: EFColorViewDelegate? { get set }

    // The current color.
    var color: UIColor { get set }
}
