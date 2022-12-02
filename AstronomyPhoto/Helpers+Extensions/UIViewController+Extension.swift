//
//  UIViewController+Extension.swift
//  AstronomyPhoto
//
//  Created by Julia Frederico on 01/12/22.
//

import UIKit

extension UIViewController {
    
    func presentAlert(title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let dismissAction = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(dismissAction)
        
        present(alert, animated: true)
    }
    
    func presentLoading(_ loadingVC: LoadingViewController) {
        loadingVC.modalPresentationStyle = .overCurrentContext
        loadingVC.modalTransitionStyle = .crossDissolve
        
        present(loadingVC, animated: true)
    }
    
    func removeLoading(_ loadingVC: LoadingViewController, completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear]) {
            loadingVC.view.alpha = 0
        } completion: { _ in
            loadingVC.dismiss(animated: false) {
                completion()
            }
        }
    }

}
