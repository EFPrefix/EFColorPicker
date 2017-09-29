//
//  ViewController.swift
//  EFColorPicker
//
//  Created by EyreFree on 09/28/2017.
//  Copyright (c) 2017 EyreFree. All rights reserved.
//

import UIKit
import EFColorPicker

class ViewController: UIViewController, UIPopoverPresentationControllerDelegate, MSColorSelectionViewControllerDelegate {

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
            if let colorSelectionController = destNav.visibleViewController as? MSColorSelectionViewController {
                colorSelectionController.delegate = self
                colorSelectionController.color = self.view.backgroundColor ?? UIColor.white

                if UIUserInterfaceSizeClass.compact == self.traitCollection.horizontalSizeClass {
                    let doneBtn: UIBarButtonItem = UIBarButtonItem(
                        title: NSLocalizedString("Done", comment: ""),
                        style: UIBarButtonItemStyle.done,
                        target: self,
                        action: #selector(ms_dismissViewController(sender:))
                    )
                    colorSelectionController.navigationItem.rightBarButtonItem = doneBtn
                }
            }
        }
    }

    @IBAction func onButtonClick(_ sender: UIButton) {
        let colorSelectionController = MSColorSelectionViewController()
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
                action: #selector(ms_dismissViewController(sender:))
            )
            colorSelectionController.navigationItem.rightBarButtonItem = doneBtn
        }
        self.present(navCtrl, animated: true, completion: nil)
    }

    // MARK:- MSColorViewDelegate
    func colorViewController(colorViewCntroller: MSColorSelectionViewController, didChangeColor color: UIColor) {
        self.view.backgroundColor = color
        print(color)
    }

    // MARK:- Private
    @objc func ms_dismissViewController(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}
