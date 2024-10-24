//
//  Array+Helper.swift
//  CapstoneProjectUI
//
//  Created by Nizamet Özkan on 24.10.2024.
//

extension Array {
    subscript(safe index: Int) -> Element? {
        get {
            let indexInRange = startIndex <= index && index < endIndex
            if indexInRange {
                return self[index]
            } else {
                return nil
            }
        }
        set {
            guard let _newValue = newValue else { return }
            let indexInRange = startIndex <= index && index < endIndex
            if indexInRange {
                self[index] = _newValue
            }
        }
    }
}
