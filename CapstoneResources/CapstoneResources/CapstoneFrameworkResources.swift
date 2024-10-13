//
//  CapstoneFrameworkResources.swift
//  CapstoneResources
//
//  Created by Nizamet Özkan on 12.10.2024.
//

import Foundation
import UIKit

private class BundleFinder {}
extension Foundation.Bundle {
    static let module: Bundle = {
        let bundleName = "CapstoneResourcesBundle"
        var candidates = [
            Bundle.main.resourceURL,
            Bundle(for: BundleFinder.self).resourceURL,
            Bundle.main.bundleURL,
        ]
        
        for candidate in candidates {
            let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
            print("Checking bundle path: \(bundlePath?.absoluteString ?? "nil")")
            if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                return bundle
            }
        }
        fatalError("Unable to find bundle named \(bundleName)")
    }()
}

//public class ResourcesCapstone {
//    public let name = "CapstoneResources"
//    public init() {}
//    
//    public func loadImage() -> UIImage? {
//        UIImage(
//            named: "StaticFramework3Resources-tuist",
//            in: .module,
//            compatibleWith: nil
//        )
//    }
//}

public enum CapstoneResourcesAsset: Sendable {
    public static let arrowUpwardAltArrowUpwardAltSymbol = CapstoneResourcesImages(name: "arrowUpwardAltArrowUpwardAltSymbol")
    public static let arrowUploadProgressArrowUploadProgressSymbol = CapstoneResourcesImages(name: "arrowUploadProgressArrowUploadProgressSymbol")
    public static let arrowUploadReadyArrowUploadReadySymbol = CapstoneResourcesImages(name: "arrowUploadReadyArrowUploadReadySymbol")
    
    public static let main = CapstoneResourcesStoryboard(name: "Main")
}

public struct CapstoneResourcesStoryboard: Sendable {
    public let name: String
    
    public init(name: String) {
        self.name = name
    }
    
    public var storyboard: UIStoryboard {
        let bundle = Bundle.module
        let storyboard = UIStoryboard(name: name, bundle: bundle)
        return storyboard
    }
}

public struct CapstoneResourcesImages: Sendable {
    public let name: String
    
    public init(name: String) {
        self.name = name
    }
    
    public var image: UIImage {
        let bundle = Bundle.module
        let image = UIImage(named: name, in: bundle, compatibleWith: nil)
        guard let result = image else {
            fatalError("Unable to load image asset named \(name).")
        }
        return result
    }
}
