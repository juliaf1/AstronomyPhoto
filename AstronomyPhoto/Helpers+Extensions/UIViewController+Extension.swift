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
    
    func presentActivity(for apod: APOD) {
        let defaultImage = UIImage(named: Strings.defaultPhotoName)!
        let detail = "Check this cool Astronomy Photo from NASA: \(apod.title)"
        
        let activity = UIActivityViewController(activityItems: [detail, apod.photo ?? defaultImage], applicationActivities: nil)
        
        present(activity, animated: true)
    }
    
    func displayLike(touchPoint: CGPoint) {
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = customVerticalPath(touchPoint: touchPoint).cgPath
        animation.duration = 2
        animation.isRemovedOnCompletion = true
        animation.fillMode = .forwards
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        let imageView = UIImageView(image: UIImage(systemName: "star.fill"))
        imageView.tintColor = Colors.brandPrimary
        imageView.frame = CGRect(x: -40 , y: 0, width: 40, height: 40)
        
        imageView.layer.add(animation, forKey: nil)
        self.view.addSubview(imageView)
        
        UIView.animate(withDuration: 1.0, delay: 0.5, options: .curveEaseInOut) {
            imageView.alpha = 0
        } completion: { _ in
            imageView.removeFromSuperview()
        }
    }
    
    func customVerticalPath(touchPoint: CGPoint) -> UIBezierPath {
        let path = UIBezierPath()
        
        let pathLength: CGFloat = 400
        let curveLength: CGFloat = pathLength / 4
        
        path.move(to: touchPoint)
        
        let endpoint = CGPoint(x: touchPoint.x, y: touchPoint.y - pathLength)
        
        let curve1 = CGPoint(x: touchPoint.x - 50, y: touchPoint.y - curveLength)
        let curve2 = CGPoint(x: touchPoint.x + 50, y: touchPoint.y - (3 * curveLength))
        
        path.addCurve(to: endpoint, controlPoint1: curve1, controlPoint2: curve2)
        
        return path
    }

}
