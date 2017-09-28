//
//  UIControl+HitTestEdgeInsets.swift
//  EFColorPicker
//
//  Created by EyreFree on 2017/9/28.
//

import UIKit

class EFControl: UIControl {

    /// Edge inset values are applied to a view bounds to shrink or expand the touchable area.
    var hitTestEdgeInsets: UIEdgeInsets = UIEdgeInsets.zero

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if UIEdgeInsetsEqualToEdgeInsets(self.hitTestEdgeInsets, UIEdgeInsets.zero)
            || !self.isEnabled
            || self.isHidden
            || !self.isUserInteractionEnabled
            || 0 == self.alpha {
            return super.point(inside: point, with: event)
        }

        let hitFrame: CGRect = UIEdgeInsetsInsetRect(self.bounds, self.hitTestEdgeInsets)
        return hitFrame.contains(point)
    }
}
