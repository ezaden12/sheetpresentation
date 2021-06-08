//
//  ViewController.swift
//  sheetpresentation
//
//  Created by Muhamed Ezaden Seraj on 8/6/21.
//

import UIKit

class HomeViewController: UIViewController {

    let sheetTransitioningDelegate = TransitioningDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .purple

        navigationItem.rightBarButtonItem = .init(title: "Tap me!", style: .done, target: self, action: #selector(handleAction))
    }

    @objc func handleAction() {
        let controller = SheetPage()
        controller.transitioningDelegate = self.sheetTransitioningDelegate
        controller.modalPresentationStyle = .custom
        self.present(controller, animated: true)
    }
}

