//
//  DispatchQueueInterface.swift
//  CapstoneProjectUI
//
//  Created by Nizamet Özkan on 24.10.2024.
//

import Foundation

public protocol DispatchQueueInterface {
    func async(execute work: @escaping @convention(block) () -> Void)
    func asyncAfter(delay: TimeInterval, execute work: @escaping @convention(block) () -> Void)
}

extension DispatchQueue: DispatchQueueInterface {
    public func async(execute work: @escaping @convention(block) () -> Void) {
        async(group: nil, execute: work)
    }
    
    public func asyncAfter(delay: TimeInterval, execute work: @escaping @convention(block) () -> Void) {
        let dispatchTime: DispatchTime = DispatchTime.now() + delay
        asyncAfter(deadline: dispatchTime, execute: work)
    }
}
