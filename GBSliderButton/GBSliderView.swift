//
//  GBSliderView.swift
//  GBSliderButton
//
//  Created by Apple on 06/08/18.
//  Copyright © 2018 Batth. All rights reserved.
//

import UIKit

@objc protocol GBSliderButtonDelegate: class {
    func sliderComplete()
}

@IBDesignable
class GBSliderView: UIView {

    @IBInspectable var image: UIImage?{
        didSet{
            imageView.image = image
            if localImage == nil{
                localImage = image
            }
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 35{
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 1.5{
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor?{
        didSet{
            self.layer.borderColor = borderColor?.cgColor
        }
    }
    
    @IBInspectable var text: String?{
        didSet{
            self.lbl.text = text
        }
    }
    
    var font : UIFont = UIFont.systemFont(ofSize: 17){
        didSet{
            self.lbl.font = font
        }
    }
    
    @IBInspectable var fontColor: UIColor?{
        didSet{
            self.lbl.textColor = fontColor
        }
    }
    
    @IBOutlet weak var gbSliderDelegate: GBSliderButtonDelegate?
    
//MARK:-  Private Properties
    private var isDelegateCalled: Bool = false
    
    private var localImage: UIImage?
    
    private lazy var imageView: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.isUserInteractionEnabled = true
        img.contentMode = .scaleAspectFit
        img.clipsToBounds = true
        img.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(moveImageView(_ :))))
        img.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(reset)))
        return img
    }()
    
    private lazy var lbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
//MARK:-  Compulsory Funcations
    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addView()
    }
    
//MARK:-  Private Functions
    private func addView(){
        self.layer.masksToBounds = true
        self.addSubview(lbl)
        lbl.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        lbl.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        lbl.text = "GBSlider"
        
        self.addSubview(imageView)
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    @objc private func moveImageView(_ gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: self)
        imageView.transform = CGAffineTransform(translationX: imageView.center.x + translation.x, y: 0)
        print(translation.x)
        print(self.bounds.width - imageView.bounds.width)
        if !isDelegateCalled{
            if translation.x  >= (self.bounds.width - imageView.bounds.width){
                self.gbSliderDelegate?.sliderComplete()
                isDelegateCalled = true
            }
        }
        switch gesture.state {
        case .began:
            break
        case .changed:
            break
        case .cancelled:
            break
        case .ended:
            if translation.x < (self.bounds.width - imageView.bounds.width) {
                UIView.animate(withDuration: 0.2) {
                    self.imageView.transform = .identity
                }
            }else if translation.x > (self.bounds.width - imageView.bounds.width){
                imageView.transform = CGAffineTransform(translationX: self.bounds.width - imageView.bounds.width, y: 0)
                self.imageView.isUserInteractionEnabled = false
            }
        case .failed:
            break
        case .possible:
            break
        }
    }
    
    @objc func reset(){
        self.imageView.isUserInteractionEnabled = true
        self.isDelegateCalled = false
        self.imageView.image = localImage
        UIView.animate(withDuration: 0.2) {
            self.imageView.transform = .identity
        }
    }
}
