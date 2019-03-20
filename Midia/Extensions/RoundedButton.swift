//
//  RoundedButton.swift
//  MeshApp
//
//  Created by Alberto García-Muñoz on 28/01/2019.
//  Copyright © 2019 AlbGarciam. All rights reserved.
//

import UIKit

@IBDesignable
final class RoundedButton: UIButton {
    
    private var sublayer = CALayer()
    @IBInspectable var buttonColor: UIColor = .clear {
        didSet {
            sublayer.backgroundColor = buttonColor.cgColor
        }
    }
    
    @IBInspectable var borderColor: UIColor = .white {
        didSet {
            sublayer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            sublayer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var shadowEnabled: Bool = false {
        didSet {
            layer.shadowColor = shadowEnabled ? buttonColor.cgColor : UIColor.clear.cgColor
            layer.shadowOpacity = shadowEnabled ? 0.75 : 0
            layer.shadowOffset = CGSize(width: 2, height: 2)
            layer.shadowRadius = 5
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        self.addTarget(self, action: #selector(touchDownInside), for: .touchDown)
        self.addTarget(self, action: #selector(touchUp), for: .touchUpInside)
        self.addTarget(self, action: #selector(touchUp), for: .touchUpOutside)
        guard let subview = imageView ?? titleLabel else { return }
        layer.insertSublayer(sublayer, below: subview.layer)
        self.adjustsImageWhenHighlighted = false
        
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        sublayer.masksToBounds = true
        sublayer.frame = bounds
        sublayer.cornerRadius = bounds.height / 2
    }
    
    @objc private func touchDownInside() {
        UIView.animate(withDuration: 0.15, delay: 0.0, options: [.allowUserInteraction, .curveEaseIn], animations: { [weak self] in
            self?.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self?.layer.shadowOffset = .zero
            self?.layer.shadowRadius = 2
        }, completion: nil)
    }
    
    @objc private func touchUp() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.allowUserInteraction, .curveEaseOut], animations: { [weak self] in
            self?.transform = CGAffineTransform.identity
            self?.layer.shadowOffset = CGSize(width: 2, height: 2)
            self?.layer.shadowRadius = 5
        }, completion: nil)
    }

}
