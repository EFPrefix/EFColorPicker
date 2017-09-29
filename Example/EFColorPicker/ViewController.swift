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
                if let color = self.view.backgroundColor {
                    colorSelectionController.color = color
                }

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

    @IBAction func onButtonTap(button: UIButton) {
        let colorSelectionController = MSColorSelectionViewController()
        let navCtrl = UINavigationController(rootViewController: colorSelectionController)

        navCtrl.modalPresentationStyle = UIModalPresentationStyle.popover
        navCtrl.popoverPresentationController?.delegate = self
        navCtrl.popoverPresentationController?.sourceView = button
        navCtrl.popoverPresentationController?.sourceRect = button.bounds
        navCtrl.preferredContentSize = colorSelectionController.view.systemLayoutSizeFitting(UILayoutFittingCompressedSize)

        colorSelectionController.delegate = self
        if let color = self.view.backgroundColor {
            colorSelectionController.color = color
        }

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
    }

    //#pragma mark - UIAdaptivePresentationControllerDelegate methods
    //
    //- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
    //{
    //    return UIModalPresentationFullScreen;
    //}

    // MARK:- Private
    @objc func ms_dismissViewController(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}
