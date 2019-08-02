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

import UIKit
import EFColorPicker

class ViewController: UIViewController, UIPopoverPresentationControllerDelegate, EFColorSelectionViewControllerDelegate {

    @IBOutlet weak var testButton: UIButton!
    var isColorTextFieldHidden: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "EFColorPicker"
        self.view.backgroundColor = UIColor.white

        testButton.layer.borderColor = UIColor.black.cgColor
        testButton.layer.cornerRadius = 4.5
        testButton.layer.borderWidth = 0.5
        testButton.setTitleColor(UIColor.black, for: .normal)
        testButton.setTitle("isColorTextFieldHidden: \(isColorTextFieldHidden)", for: .normal)
        testButton.addTarget(self, action: #selector(onTestButtonClick(_:)), for: .touchUpInside)
    }

    //
    @objc func onTestButtonClick(_ sender: UIButton) {
        isColorTextFieldHidden = !isColorTextFieldHidden
        testButton.setTitle("isColorTextFieldHidden: \(isColorTextFieldHidden)", for: .normal)
    }

    // Programmatically
    @IBAction func onButtonClick(_ sender: UIButton) {
        let colorSelectionController = EFColorSelectionViewController()

        let navCtrl = UINavigationController(rootViewController: colorSelectionController)
        navCtrl.navigationBar.backgroundColor = UIColor.white
        navCtrl.navigationBar.isTranslucent = false
        navCtrl.modalPresentationStyle = UIModalPresentationStyle.popover
        navCtrl.popoverPresentationController?.delegate = self
        navCtrl.popoverPresentationController?.sourceView = sender
        navCtrl.popoverPresentationController?.sourceRect = sender.bounds
        navCtrl.preferredContentSize = colorSelectionController.view.systemLayoutSizeFitting(
            UIView.layoutFittingCompressedSize
        )

        colorSelectionController.isColorTextFieldHidden = isColorTextFieldHidden
        colorSelectionController.delegate = self
        colorSelectionController.color = self.view.backgroundColor ?? UIColor.white
        // colorSelectionController.setMode(mode: EFColorSelectionMode.hsb)

        if UIUserInterfaceSizeClass.compact == self.traitCollection.horizontalSizeClass {
            let doneBtn: UIBarButtonItem = UIBarButtonItem(
                title: NSLocalizedString("Done", comment: ""),
                style: UIBarButtonItem.Style.done,
                target: self,
                action: #selector(ef_dismissViewController(sender:))
            )
            colorSelectionController.navigationItem.rightBarButtonItem = doneBtn
        }
        self.present(navCtrl, animated: true, completion: nil)
    }

    // Storyboard
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if "showPopover" == segue.identifier {
            guard let destNav: UINavigationController = segue.destination as? UINavigationController else {
                return
            }
            if let size = destNav.visibleViewController?.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize) {
                destNav.preferredContentSize = size
            }
            destNav.popoverPresentationController?.delegate = self
            if let colorSelectionController = destNav.visibleViewController as? EFColorSelectionViewController {
                colorSelectionController.isColorTextFieldHidden = isColorTextFieldHidden
                colorSelectionController.delegate = self
                colorSelectionController.color = self.view.backgroundColor ?? UIColor.white

                if UIUserInterfaceSizeClass.compact == self.traitCollection.horizontalSizeClass {
                    let doneBtn: UIBarButtonItem = UIBarButtonItem(
                        title: NSLocalizedString("Done", comment: ""),
                        style: UIBarButtonItem.Style.done,
                        target: self,
                        action: #selector(ef_dismissViewController(sender:))
                    )
                    colorSelectionController.navigationItem.rightBarButtonItem = doneBtn
                }
            }
        }
    }

    // MARK:- EFColorSelectionViewControllerDelegate
    func colorViewController(_ colorViewCntroller: EFColorSelectionViewController, didChangeColor color: UIColor) {
        self.view.backgroundColor = color

        // TODO: You can do something here when color changed.
        print("New color: " + color.debugDescription)
    }

    // MARK:- Private
    @objc func ef_dismissViewController(sender: UIBarButtonItem) {
        self.dismiss(animated: true) {
            [weak self] in
            if let _ = self {
                // TODO: You can do something here when EFColorPicker close.
                print("EFColorPicker closed.")
            }
        }
    }
}
