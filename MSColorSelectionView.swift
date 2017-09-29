//
//  MSColorSelectionView.swift
//  EFColorPicker
//
//  Created by EyreFree on 2017/9/29.
//

import Foundation

// The enum to define the MSColorView's types.
enum MSSelectedColorView: UInt {
    // The RGB color view type.
    case RGB = 0

    // The HSB color view type.
    case HSB = 1
}

// The MSColorSelectionView aggregates views that should be used to edit color components.
/*
class MSColorSelectionView: UIView, MSColorView, MSColorViewDelegate {

    // The selected color view
    private(set) var selectedIndex: MSSelectedColorView

    // Makes a color component view (rgb or hsb) visible according to the index.
    // @param index    This index define a view to show.
    // @param animated If YES, the view is being appeared using an animation.
    func setSelectedIndex(index: MSSelectedColorView, animated: Bool) {

    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
}
*/
