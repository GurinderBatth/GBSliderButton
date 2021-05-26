//
//  GBSliderView.swift
//  GBSliderButton
//
//  Created by Apple on 06/08/18.
//  Copyright © 2018 Batth. All rights reserved.
//

import UIKit

enum GBSliderDirection: String{
    case left
    case right
}

protocol GBSliderButtonDelegate {
    func sliderComplete(direction: GBSliderDirection)
}

@IBDesignable
class GBSliderView: UIView {

    @IBInspectable var intialImage: UIImage?{
        didSet{
            imageView.image = intialImage
        }
    }
    
    @IBInspectable var finalImage: UIImage?{
        didSet{
            if finalImage == nil{
                imageView.image = intialImage
            }else{
                imageView.image = finalImage
            }
        }
    }
    
    var direction = GBSliderDirection.left{
        didSet{
            setupTheDirection()
        }
    }
    
    @available(*, unavailable, message: "This property is reserved for Interface Builder. Use 'direction' instead.")
    @IBInspectable var sliderDirection: String = "left"{
        willSet{
            if let newDirection = GBSliderDirection(rawValue: newValue.lowercased()){
                direction = newDirection
                setupTheDirection()
            }
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 1.5{
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var intialBorderColor: UIColor? = .clear{
        didSet{
            self.layer.borderColor = intialBorderColor?.cgColor
        }
    }
    
    @IBInspectable var finalBorderColor: UIColor? = .clear{
        didSet{
            if finalBorderColor == nil{
                self.layer.borderColor = intialBorderColor?.cgColor
            }else{
                self.layer.borderColor = finalBorderColor?.cgColor
            }
        }
    }
    
    @IBInspectable var intialText: String?{
        didSet{
            self.lbl.text = intialText
        }
    }
    
    @IBInspectable var finalText: String?{
        didSet{
            if finalText == nil{
                self.lbl.text = intialText
            }else{
                self.lbl.text = finalText
            }
        }
    }
    
    var font : UIFont = UIFont.systemFont(ofSize: 17){
        didSet{
            self.lbl.font = font
        }
    }
    
    @IBInspectable var intialFontColor: UIColor?{
        didSet{
            self.lbl.textColor = intialFontColor
        }
    }
    
    @IBInspectable var finalFontColor: UIColor?{
        didSet{
            if finalFontColor == nil{
                self.lbl.textColor = intialFontColor
            }else{
                self.lbl.textColor = finalFontColor
            }
        }
    }
    
    @IBInspectable var intialBackgroundColor: UIColor?{
        didSet{
            self.backgroundColor = intialBackgroundColor
        }
    }
    
    @IBInspectable var finalBackgroundColor: UIColor?{
        didSet{
            if finalBackgroundColor == nil{
                self.backgroundColor = intialBackgroundColor
            }else{
                self.backgroundColor = finalBackgroundColor
            }
        }
    }
    
    var gbSliderDelegate: GBSliderButtonDelegate?
        
//MARK:-  Private Properties
    private var isDelegateCalled: Bool = false
    
    private lazy var imageView: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.isUserInteractionEnabled = true
        img.contentMode = .scaleAspectFit
        img.clipsToBounds = true
        img.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(moveImageView(_ :))))
        return img
    }()
    
    private lazy var lbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    
    private func setupLeftSwipeGesture(){
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeGesture(_:)))
        swipeGesture.direction = .left
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(swipeGesture)
    }
    
    private func setupRightSwipeGesture(){
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeGesture(_:)))
        swipeGesture.direction = .right
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(swipeGesture)
    }
    
//MARK:-  Compulsory Funcations
    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
        setupLeftSwipeGesture()
        setupRightSwipeGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addView()
        setupLeftSwipeGesture()
        setupRightSwipeGesture()
    }
    
    override func prepareForInterfaceBuilder() {
        setupView()
        setupTheDirection()
    }
    
    override func layoutSubviews() {
        setupView()
        setupTheDirection()
    }
    
//MARK:-  Private Functions
    private func setupView(){
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.lbl.font = font
        self.setupTheDirection()
    }
    
    private func setupTheDirection(){
        switch direction {
        case .left:
            imageView.transform = .identity
            self.colors(direction: .left)
        case .right:
            self.layoutIfNeeded()
            imageView.transform = CGAffineTransform(translationX: self.bounds.width - imageView.bounds.width, y: 0)
            self.colors(direction: .right)
        }
    }
    
    private func addView(){
        self.layer.masksToBounds = true
        self.addSubview(lbl)
        lbl.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        lbl.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        lbl.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        lbl.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        lbl.text = "GBSlider"
        
        self.addSubview(imageView)
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    @objc private func moveImageView(_ gesture: UIPanGestureRecognizer) {

        let translation = gesture.translation(in: self)
        panGestureLogic(translation)
        switch gesture.state {
        case .began:
            break
        case .changed:
            break
        case .cancelled:
            break
        case .ended:
            if imageView.frame.origin.x <= self.bounds.width / 2{
                UIView.animate(withDuration: 0.2, animations: {
                    self.imageView.transform = .identity
                }){ completed in
                    if completed{
                        self.colors(direction: .left)
                    }
                }
            }else if imageView.frame.origin.x > self.bounds.width / 2{
                UIView.animate(withDuration: 0.2, animations:{
                    self.imageView.transform = CGAffineTransform(translationX: self.bounds.width - self.imageView.bounds.width, y: 0)
                }){ completed in
                    if completed{
                        self.colors(direction: .right)
                    }
                }
            }
        case .failed:
            break
        case .possible:
            break
        @unknown default:
            break
        }
    }
    
    @objc private func swipeGesture(_ gesture: UISwipeGestureRecognizer){
        switch gesture.direction {
        case .left:
            UIView.animate(withDuration: 0.2, animations: { [unowned self] in
                self.imageView.transform = .identity
                print(self.imageView.frame)
            }) { (completed) in
                if completed {
                    self.gbSliderDelegate?.sliderComplete(direction: .left)
                    self.colors(direction: .left)
                }
            }
        case .right:
            UIView.animate(withDuration: 0.2, animations:  { [unowned self] in
                self.imageView.transform = CGAffineTransform(translationX: self.bounds.width - self.imageView.bounds.width, y: 0)
            }) { completed in
                if completed{
                    self.gbSliderDelegate?.sliderComplete(direction: .right)
                    self.colors(direction: .right)
                }
            }
        default:
            break
        }
    }
        
    private func colors(direction: GBSliderDirection){
        switch direction {
        case .left:
            self.imageView.image = self.intialImage
            self.backgroundColor = self.intialBackgroundColor
            self.lbl.text = self.intialText
            self.lbl.textColor = self.intialFontColor
            self.layer.borderColor = self.intialBorderColor?.cgColor
        case .right:
            self.imageView.image = self.finalImage
            self.backgroundColor = self.finalBackgroundColor
            self.lbl.text = self.finalText
            self.lbl.textColor = self.finalFontColor
            self.layer.borderColor = self.finalBorderColor?.cgColor
        }
    }
    
    private func panGestureLogic(_ translation: CGPoint){
        if translation.x > 0{
            if imageView.frame.origin.x >= (self.bounds.width - imageView.bounds.width){
                if !isDelegateCalled{
                    self.gbSliderDelegate?.sliderComplete(direction: .right)
                    self.colors(direction: .right)
                    isDelegateCalled = true
                }
            }else{
                isDelegateCalled = false
                imageView.transform = CGAffineTransform(translationX: imageView.center.x + translation.x, y: 0)
            }
        }else if translation.x < 0{
            if imageView.frame.origin.x > 0{
                imageView.transform = CGAffineTransform(translationX: (self.bounds.width - imageView.bounds.width) + translation.x, y: 0)
                self.isDelegateCalled = false
            }else{
                if !isDelegateCalled{
                    self.gbSliderDelegate?.sliderComplete(direction: .left)
                    self.colors(direction: .left)
                    self.isDelegateCalled = true
                }
            }
        }
    }
}
