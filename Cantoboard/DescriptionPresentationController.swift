//
//  DescriptionPresentationController.swift
//  Cantoboard
//
//  Created by Alex Man on 23/11/21.
//

import UIKit

class DescriptionPresentationController: UIPresentationController {
    lazy var backdropView: UIView = {
        let backdropView = UIView(frame: containerView!.frame)
        backdropView.backgroundColor = .systemFill.withAlphaComponent(0.2)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissPresentedViewController))
        tapGestureRecognizer.cancelsTouchesInView = false
        backdropView.addGestureRecognizer(tapGestureRecognizer)
        return backdropView
    }()
    
    override var frameOfPresentedViewInContainerView: CGRect {
        let bounds = containerView!.bounds
        let description = presentedViewController as! UINavigationController
        description.view.layoutIfNeeded()
        let height = (description.children[0] as! DescriptionViewController).stackView.bounds.height + description.navigationBar.bounds.height + description.view.safeAreaInsets.top + description.view.safeAreaInsets.bottom
        return CGRect(x: 0, y: bounds.height - height, width: bounds.width, height: height)
    }
    
    override func presentationTransitionWillBegin() {
        backdropView.alpha = 0
        containerView!.addSubview(backdropView)
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in self.backdropView.alpha = 1 })
    }
    
    override func dismissalTransitionWillBegin() {
        backdropView.alpha = 1
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in self.backdropView.alpha = 0 }) { _ in
            self.backdropView.removeFromSuperview()
        }
    }
    
    @objc func dismissPresentedViewController() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}
