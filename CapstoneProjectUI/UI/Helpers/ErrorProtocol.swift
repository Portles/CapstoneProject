//
//  ErrorProtocol.swift
//  CapstoneProjectUI
//
//  Created by Nizamet Özkan on 24.10.2024.
//

public protocol Errorable {
    func handleError(_ error: Error)
}

extension Errorable {
    public func handleError(_ error: Error) {
        debugPrint(error.localizedDescription)
    }
}
