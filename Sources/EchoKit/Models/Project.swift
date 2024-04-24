//
//  Project.swift
//
//
//  Created by Lukas on 4/24/24.
//

import Foundation

internal final class Project {
    
    internal static var name: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
        ?? Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
        ?? "App Name Not Found"
    }
    
    internal static var version: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        ?? "Version Not Found"
    }
    
    internal static var buildNumber: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
        ?? "Build Number Not Found"
    }
    
    internal static var info: String {
        "App name: \(name)"
        + "\n"
        + "Version: \(version)"
        + "\n"
        + "Build number: \(buildNumber)"
    }
}
