//
//  ProductStepperView.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 7.10.2024.
//

import UIKit

class BuyView: UIView {
    private(set) var counter: Int = 0 {
        didSet {
            counterLabel.text = "\(counter)"
            setButtonsEnability(counter)
        }
    }
    
    private let increamentButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.arrowUpwardAltArrowUpwardAltSymbol, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .orange
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        return button
    }()
    
    private let counterLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "0"
        label.font = .preferredFont(forTextStyle: .title1)
        label.textAlignment = .center
        return label
    }()
    
    private let decreamentButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.arrowUpwardAltArrowUpwardAltSymbol, for: .normal)
        button.transform = button.transform.rotated(by: .pi)
        button.isEnabled = false
        button.tintColor = .white
        button.backgroundColor = .orange
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        return button
    }()
    
    let buttonAddToCart: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("Add to Cart", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemOrange
        button.layer.cornerRadius = 10
        button.isEnabled = false
        button.layer.opacity = 0.3
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(increamentButton)
        addSubview(counterLabel)
        addSubview(decreamentButton)
        addSubview(buttonAddToCart)
        
        let increaseCounterAction: UIAction = {
            UIAction { [unowned self] _ in
                self.counter += 1
            }
        }()
        
        let decreaseCounterAction: UIAction = {
            UIAction { [unowned self] _ in
                if self.counter > 0 {
                    self.counter -= 1
                }
            }
        }()
        
        increamentButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchDown)
        increamentButton.addAction(increaseCounterAction, for: .touchDown)
        increamentButton.addTarget(self, action: #selector(buttonReleased(_:)), for: [.touchUpInside, .touchUpOutside])
        
        decreamentButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchDown)
        decreamentButton.addAction(decreaseCounterAction, for: .touchDown)
        decreamentButton.addTarget(self, action: #selector(buttonReleased(_:)), for: [.touchUpInside, .touchUpOutside])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        decreamentButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        counterLabel.frame = CGRect(x: decreamentButton.right + 20, y: 0, width: 50, height: 50)
        increamentButton.frame = CGRect(x: counterLabel.right + 20, y: 0, width: 50, height: 50)
        buttonAddToCart.frame = CGRect(x: 0, y: increamentButton.bottom + 32, width: width, height: 42)
    }
    
    @objc private func buttonPressed(_ sender: UIButton) {
        UIView.transition(with: sender, duration: 0.3, options: .transitionCrossDissolve, animations: {
            sender.setImage(UIImage.arrowUploadProgressArrowUploadProgressSymbol, for: .normal)
        }, completion: nil)
    }
    
    @objc private func buttonReleased(_ sender: UIButton) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIView.transition(with: sender, duration: 0.3, options: .transitionCrossDissolve, animations: {
                sender.setImage(UIImage.arrowUploadReadyArrowUploadReadySymbol, for: .normal)
            }, completion: { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    UIView.transition(with: sender, duration: 0.3, options: .transitionCrossDissolve, animations: {
                        sender.setImage(UIImage.arrowUpwardAltArrowUpwardAltSymbol, for: .normal)
                    }, completion: nil)
                }
            })
        }
    }
    
    private func setButtonsEnability(_ counter: Int) {
        if counter == 0 {
            decreamentButton.isEnabled = false
            buttonAddToCart.isEnabled = false
            buttonAddToCart.layer.opacity = 0.3
        } else {
            decreamentButton.isEnabled = true
            buttonAddToCart.isEnabled = true
            buttonAddToCart.layer.opacity = 1.0
        }
    }
}
