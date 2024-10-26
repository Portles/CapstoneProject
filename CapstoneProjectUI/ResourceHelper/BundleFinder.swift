//
//  BundleFinder.swift
//  CapstoneProjectUI
//
//  Created by Nizamet Özkan on 18.10.2024.
//

import Foundation
import UIKit

private class BundleFinder {}

extension Foundation.Bundle {
    static let module: Bundle = {
        let bundleName = "CapstoneProjectUIResources"
        var candidates = [
            Bundle.main.resourceURL,
            Bundle(for: BundleFinder.self).resourceURL,
            Bundle.main.bundleURL,
        ]
        if let override = ProcessInfo.processInfo.environment["PACKAGE_RESOURCE_BUNDLE_PATH"] {
            candidates.append(URL(fileURLWithPath: override))
            if let subpaths = try? FileManager.default.contentsOfDirectory(atPath: override) {
                for subpath in subpaths where subpath.hasSuffix(".framework") {
                    candidates.append(URL(fileURLWithPath: override + "/" + subpath))
                }
            }
        }
        for candidate in candidates {
            let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
            if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                return bundle
            }
        }
        fatalError("unable to find bundle named CapstoneProjectUIResources")
    }()
}

public enum CapstoneProjectUIResourcesAsset: Sendable {
  public static let uploadProgress = CapstoneProjectUIResourcesImages(name: "arrow_upload_progress_arrow_upload_progress_symbol")
    public static let uploadReady = CapstoneProjectUIResourcesImages(name: "arrow_upload_ready_arrow_upload_ready_symbol")
    public static let upwardAlt = CapstoneProjectUIResourcesImages(name: "arrow_upward_alt_arrow_upward_alt_symbol")

}

public struct CapstoneProjectUIResourcesImages: Sendable {
    public let name: String
    
    public var image: UIImage {
        let bundle = Bundle.module
        let image = UIImage(named: name, in: bundle, compatibleWith: nil)
        guard let result = image else {
            fatalError("Unable to load image asset named \(name).")
        }
        return result
    }
}
