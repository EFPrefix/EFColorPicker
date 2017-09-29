//
//  MSColorView.swift
//  EFColorPicker
//
//  Created by EyreFree on 2017/9/28.
//

import UIKit

//  The delegate of a MSColorView object must adopt the MSColorViewDelegate protocol.
//  Methods of the protocol allow the delegate to handle color value changes.
protocol MSColorViewDelegate {

    // Tells the data source to return the color components.
    // @param colorView The color view.
    // @param color The new color value.
    func colorView(colorView: MSColorView, didChangeColor color: UIColor)
}

/// The \c MSColorView protocol declares a view's interface for displaying and editing color value.
protocol MSColorView {

    // The object that acts as the delegate of the receiving color selection view.
    var delegate: MSColorViewDelegate? { get set }

    // The current color.
    var color: UIColor { get set }
}
