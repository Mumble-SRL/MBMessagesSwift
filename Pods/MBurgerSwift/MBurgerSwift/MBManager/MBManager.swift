//
//  MBManager.swift
//  MBurgerSwift
//
//  Created by Alessandro Viviani on 26/09/2019.
//  Copyright © 2019 Mumble S.r.l (https://mumbleideas.it/). All rights reserved.
//

import Foundation

/// The manager of the SDK.
public final class MBManager {
    private init() { }
    
    /// Creates and returns a singleton `MBManager`.
    /// - Warning: Don't allocate an instance of MBManager yourself.
    public static let shared = MBManager()
    
    /// The API token used to make all the requests to the api.
    public var apiToken: String = ""
    
    /// It's true if it's in development mode.
    public var development: Bool = false
    
    /// An array of plugin objects that can add functionality to the core MBurger.
    public var plugins: [MBPluginProtocol] = []
    
    /// The locale used to make the requests.
    public var locale: Locale?
    
    /// The locale string sended to the api.
    public var localeString: String {
        return localeForApi()
    }
    
    private func localeForApi() -> String {
        if let locale = self.locale {
            return string(forLocale: locale)
        } else {
            if let preferredLanguage = Locale.preferredLanguages.first {
                let index = preferredLanguage.index(preferredLanguage.startIndex, offsetBy: 2)
                return String(preferredLanguage.prefix(upTo: index))
            } else {
                return string(forLocale: Locale.current)
            }
        }
    }
    
    private func string(forLocale locale: Locale) -> String {
        let localeIdentifier = locale.identifier
        let index = localeIdentifier.index(localeIdentifier.startIndex, offsetBy: 2)
        return String(localeIdentifier.prefix(upTo: index))
    }
    
    public func applicationDidFinishLaunchingWithOptions(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        
        guard plugins.count != 0 else {
            return
        }
        let sortedPlugins = plugins.sorted(by: { (p1, p2) -> Bool in
            return p1.applicationStartupOrder > p2.applicationStartupOrder
        })
        var startupBlocks = [ApplicationStartupBlock]()
        for plugin in sortedPlugins {
            if let startupBlock = plugin.applicationStartupBlock() {
                startupBlocks.append(startupBlock)
            }
        }
        
        guard startupBlocks.count != 0 else {
            return
        }
        
        executeStartupBlock(index: 0,
                            startupBlocks: startupBlocks,
                            launchOptions: launchOptions)
    }
    
    private func executeStartupBlock(index: Int,
                                     startupBlocks: [ApplicationStartupBlock],
                                     launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        guard index < startupBlocks.count else {
            return
        }
        let startupBlock = startupBlocks[index]
        startupBlock(launchOptions, {
            if index + 1 < startupBlocks.count {
                self.executeStartupBlock(index: index + 1,
                                         startupBlocks: startupBlocks,
                                         launchOptions: launchOptions)
            }
        })
    }
}

extension Locale {
    func stringForLocale() -> String {
        return String(identifier.prefix(2))
    }
}
