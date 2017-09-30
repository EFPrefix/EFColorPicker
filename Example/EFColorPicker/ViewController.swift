//
//  ViewController.swift
//  EFColorPicker
//
//  Created by EyreFree on 09/28/2017.
//  Copyright (c) 2017 EyreFree. All rights reserved.
//

import UIKit
//
//  ViewController.swift
//  EFColorPicker
//
//  Created by EyreFree on 2017/9/28.
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

import EFColorPicker

class ViewController: UIViewController, UIPopoverPresentationControllerDelegate, EFColorSelectionViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if "showPopover" == segue.identifier {
            guard let destNav: UINavigationController = segue.destination as? UINavigationController else {
                return
            }
            if let size = destNav.visibleViewController?.view.systemLayoutSizeFitting(UILayoutFittingCompressedSize) {
                destNav.preferredContentSize = size
            }
            destNav.popoverPresentationController?.delegate = self
            if let colorSelectionController = destNav.visibleViewController as? EFColorSelectionViewController {
                colorSelectionController.delegate = self
                colorSelectionController.color = self.view.backgroundColor ?? UIColor.white

                if UIUserInterfaceSizeClass.compact == self.traitCollection.horizontalSizeClass {
                    let doneBtn: UIBarButtonItem = UIBarButtonItem(
                        title: NSLocalizedString("Done", comment: ""),
                        style: UIBarButtonItemStyle.done,
                        target: self,
                        action: #selector(ef_dismissViewController(sender:))
                    )
                    colorSelectionController.navigationItem.rightBarButtonItem = doneBtn
                }
            }
        }
    }

    @IBAction func onButtonClick(_ sender: UIButton) {
        let colorSelectionController = EFColorSelectionViewController()
        let navCtrl = UINavigationController(rootViewController: colorSelectionController)

        navCtrl.modalPresentationStyle = UIModalPresentationStyle.popover
        navCtrl.popoverPresentationController?.delegate = self
        navCtrl.popoverPresentationController?.sourceView = sender
        navCtrl.popoverPresentationController?.sourceRect = sender.bounds
        navCtrl.preferredContentSize = colorSelectionController.view.systemLayoutSizeFitting(
            UILayoutFittingCompressedSize
        )

        colorSelectionController.delegate = self
        colorSelectionController.color = self.view.backgroundColor ?? UIColor.white

        if UIUserInterfaceSizeClass.compact == self.traitCollection.horizontalSizeClass {
            let doneBtn: UIBarButtonItem = UIBarButtonItem(
                title: NSLocalizedString("Done", comment: ""),
                style: UIBarButtonItemStyle.done,
                target: self,
                action: #selector(ef_dismissViewController(sender:))
            )
            colorSelectionController.navigationItem.rightBarButtonItem = doneBtn
        }
        self.present(navCtrl, animated: true, completion: nil)
    }

    // MARK:- EFColorViewDelegate
    func colorViewController(colorViewCntroller: EFColorSelectionViewController, didChangeColor color: UIColor) {
        self.view.backgroundColor = color
        print(color)
    }

    // MARK:- Private
    @objc func ef_dismissViewController(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}
