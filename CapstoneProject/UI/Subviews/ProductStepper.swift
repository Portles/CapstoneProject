//
//  ProductStepper.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 7.10.2024.
//

import UIKit

final class ProductStepper: UIStepper {
    
    var currentValue: Int {
        Int(stepValue)
    }
    
    override func incrementImage(for state: UIControl.State) -> UIImage? {
        super.incrementImage(for: state)
        return UIImage(systemName: "plus")
    }
    
    override func decrementImage(for state: UIControl.State) -> UIImage? {
        super.decrementImage(for: state)
        return UIImage(systemName: "minus")
    }
}
