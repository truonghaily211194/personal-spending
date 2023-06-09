////
////  DisplayStampViewController.swift
////  CM
////
////  Created by Mai Anh Tuan on 4/3/17.
////  Copyright © 2017 AsianTech Co., Ltd. All rights reserved.
////

import UIKit
import SwiftUtils

let stampHeaderIconKey = "stampHeaderIcon"

class DisplayStampViewController: UIViewController {

    typealias closeClosure = () -> Void

    @IBOutlet fileprivate weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet fileprivate weak var thumImageView: UIImageView!
    @IBOutlet fileprivate weak var closeButton: UIButton!
    @IBOutlet fileprivate weak var helpButton: UIButton!
    @IBOutlet fileprivate var stampImages: [UIImageView]!
    @IBOutlet fileprivate weak var bottomView: UIView!
    @IBOutlet fileprivate weak var okButton: UIButton!
    @IBOutlet fileprivate weak var gifLabel: UILabel!
    var isAnimation = false
    var complete: closeClosure!
    var thumImage: UIImage?
    var date = App.region.today()

    fileprivate var stamp = 0
    fileprivate var gif = 0
    var totalStamp = 0 {
        didSet {
            stamp = totalStamp % 20
            gif = totalStamp / 20
            if stamp == 0 && totalStamp != 0 {
                stamp = 20
                gif -= 1
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear

        providesPresentationContextTransitionStyle = true
        definesPresentationContext = true
        modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        modalTransitionStyle = UIModalTransitionStyle.crossDissolve

        if isAnimation {
            setUpAnimation()
        } else {
            okButton.setImage(UIImage(named: "show_stamp_exchange"), for: .normal)
            setUpHeaderImage()
            loadingIndicator.stopAnimating()
            loadingIndicator.isHidden = true
            view.isHidden = true
            getStamp()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let path = UIBezierPath(roundedRect: thumImageView.bounds,
            byRoundingCorners: [.topRight, .topLeft],
            cornerRadii: CGSize(width: 10, height: 10))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        thumImageView.layer.mask = maskLayer
    }

    fileprivate func setUpAnimation() {
        loadingIndicator.isHidden = true
        loadingIndicator.stopAnimating()
        setUpHeaderImage()
        bottomView.isHidden = true
        helpButton.isHidden = true
        closeButton.isHidden = true
        okButton.isHidden = true
        okButton.alpha = 0

        if totalStamp == 0 {
            okButton.isHidden = false
            okButton.alpha = 1
            return
        }

        for i in 0 ..< stamp - 1 {
            stampImages[i].image = UIImage(named: "stamp_face")
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let this = self else { return }
            this.statAnimation(this.stamp - 1)
        }
    }

    @objc func getStamp() {
        view.isHidden = false
        totalStamp = 5 //stamp
        reloadStamp()
        loadImage("")
    }

    fileprivate func loadImage(_ thumImageUrl: String) {
        thumImage = nil
        setUpHeaderImage()
    }

    fileprivate func setUpHeaderImage() {
        if let thumImage = thumImage {
            thumImageView.image = thumImage
        } else {
            thumImageView.image = UIImage(named: "banner")
        }
    }

    func reloadStamp() {
        gifLabel.text = "\(gif)"
        for i in 0 ..< 20 {
            if i < stamp {
                if i == 19 {
                    stampImages[i].image = UIImage(named: "icons8-handshake")
                } else {
                    stampImages[i].image = UIImage(named: "stamp_face")
                }
            } else {
                stampImages[i].image = UIImage()
            }
        }
    }

    func setCloseClosure(_ complete: @escaping () -> Void) {
        self.complete = complete
    }

    func statAnimation(_ index: Int) {
        let stampImageView = stampImages[index]
        stampImageView.transform = stampImageView.transform.scaledBy(x: 5.3, y: 5.3)
        stampImageView.alpha = 0
        stampImageView.image = UIImage(named: "face5x")
        let transformRotate = CGFloat(10 / 180.0 * Double.pi)
        UIView.animate(withDuration: 0.5, animations: {
            stampImageView.alpha = 1
        }, completion: { (_) in
                UIView.animate(withDuration: 0.7, animations: {
                    stampImageView.transform = stampImageView.transform.scaledBy(x: 1.0 / 5.3, y: 1.0 / 5.3)
                    stampImageView.transform = stampImageView.transform.rotated(by: -transformRotate)
                }, completion: { (_) in
                        stampImageView.transform = stampImageView.transform.rotated(by: transformRotate)
                        if index == 19 {
                            stampImageView.image = UIImage(named: "icons8-handshake")
                            if let superView = stampImageView.superview {
                                stampImageView.frame = superView.bounds
                            }
                        } else {
                            stampImageView.image = UIImage(named: "stamp_face")
                        }
                        self.okButton.isHidden = false
                        UIView.animate(withDuration: 0.3, animations: {
                            self.okButton.alpha = 1
                        })
                    })
            })
    }

    fileprivate func handerCloseStamp() {
        if isAnimation {
            self.dismiss(animated: true, completion: {
                self.complete()
            })
        }
    }

    @IBAction func goStampTutorial(_ sender: UIButton) {
    }

    @IBAction func ok(_ sender: UIButton) {
        handerCloseStamp()
    }

    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func help(_ sender: UIButton) {

    }

    @IBAction func backgroundButtonTouchUpInside(_ sender: Any) {
        if !isAnimation {
            dismiss(animated: true, completion: nil)
        }
    }
}
