//
//  DispatchQueueInterface.swift
//  CapstoneProjectUI
//
//  Created by Nizamet Özkan on 24.10.2024.
//

import Foundation

public protocol DispatchQueueInterface {
    func async(execute work: @escaping @convention(block) () -> Void)
}

extension DispatchQueue: DispatchQueueInterface {
    public func async(execute work: @escaping @convention(block) () -> Void) {
        async(group: nil, execute: work)
    }
}
