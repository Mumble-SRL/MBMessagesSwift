//
//  MBMetadataManager.swift
//  MBurgerSwift
//
//  Created by Lorenzo Oliveto on 09/04/2020.
//  Copyright © 2020 Mumble S.r.l (https://mumbleideas.it/). All rights reserved.
//

import UIKit
import UserNotifications
import CoreLocation

class MBMetadata: NSObject, MBPluginProtocol {
    override init() {
        //TODO increment app usage counter
        MBMetadataManager.shared.updateMetadata()
    }
    
    public func setTag(withKey key: String, value: String) {
        MBMetadataManager.shared.setTag(key: key, value: value)
    }
        
    public func removeTag(withKey key: String) {
        MBMetadataManager.shared.removeTag(key: key)
    }
    
    public func setCustomId(_ customId: String) { // TODO: save it in db or file
        MBMetadataManager.shared.setCustomId(customId)
    }
    
    public func removeCustomId() {
        MBMetadataManager.shared.setCustomId(nil)
    }
    
    public func getCustomId() -> String? { // TODO: return saved objects
        return MBMetadataManager.shared.getCustomId()
    }

    public func startLocationUpdates() {
        MBMetadataManager.shared.startLocationUpdates()
    }
    
    public func stopLocationUpdates() {
        MBMetadataManager.shared.stopLocationUpdates()
    }
    
    public func didRegisterForRemoteNotifications(withDeviceToken deviceToken: Data) {
        MBMetadataManager.shared.updateMetadata()
    }
    
    func didFailToRegisterForRemoteNotifications(withError error: Error) {
        MBMetadataManager.shared.updateMetadata()
    }
}

private class MBMetadataManager: NSObject, MBPluginProtocol {
    internal static let shared = MBMetadataManager()
    
    private var locationManager: CLLocationManager?
    private var currentLocation: CLLocationCoordinate2D?

    func updateMetadata() {
        let locale = Locale.preferredLanguages.first
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        let platform = "ios"
        let current = UNUserNotificationCenter.current()

        current.getNotificationSettings(completionHandler: { [weak self] settings in
            guard let strongSelf = self else {
                return
            }
            let pushEnabled = settings.authorizationStatus == .authorized
            
            let locationAuthorizationStatus = CLLocationManager.authorizationStatus()
            let locationEnabled = locationAuthorizationStatus == .authorizedAlways || locationAuthorizationStatus == .authorizedWhenInUse
            let currentLocationData = strongSelf.currentLocation
            
            print("Call api with this data")
        })
    }
    
    func setTag(key: String, value: String) { // TODO: save it in db or file
        var newTags = getTags() ?? []
        if let indexFound = newTags.firstIndex(where: {$0.key == key}) {
            let tag = newTags[indexFound]
            tag.value = value
            newTags[indexFound] = tag
        } else {
            newTags.append(MBTag(key: key, value: value))
        }
        saveNewTags(tags: newTags)
        updateMetadata()
    }
    
    func removeTag(key: String) { // TODO: save it in db or file
        var newTags = getTags() ?? []
        if let indexFound = newTags.firstIndex(where: {$0.key == key}) {
            newTags.remove(at: indexFound)
        }
        saveNewTags(tags: newTags)
        updateMetadata()
    }

    private func saveNewTags(tags: [MBTag]) {
        let userDefaults = userDefaultsForMetadata()
        let mappedTags = tags.map({ $0.toDictoinary() })
        userDefaults.set(mappedTags, forKey: "com.mumble.mburger.tags")
    }
    
    func getTags() -> [MBTag]? {
        let userDefaults = userDefaultsForMetadata()
        guard let tags = userDefaults.object(forKey: "com.mumble.mburger.tags") as? [[String: String]] else {
            return nil
        }
        return tags.map({MBTag(dictionary: $0)})
    }
    
    func setCustomId(_ customId: String?) {
        let userDefaults = userDefaultsForMetadata()
        if let customId = customId {
            userDefaults.set(customId, forKey: "com.mumble.mburger.customId")
        } else {
            userDefaults.removeObject(forKey: "com.mumble.mburger.customId")
        }
        updateMetadata()
    }
    
    func getCustomId() -> String? {
        let userDefaults = userDefaultsForMetadata()
        return userDefaults.object(forKey: "com.mumble.mburger.customId") as? String
    }
    
    func startLocationUpdates() {
        if locationManager == nil {
            locationManager = CLLocationManager()
            locationManager?.requestAlwaysAuthorization()
            locationManager?.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager?.delegate = self
            locationManager?.startMonitoringSignificantLocationChanges()
        } else {
            locationManager?.startMonitoringSignificantLocationChanges()
        }
    }
    
    func stopLocationUpdates() {
        if let locationManager = locationManager {
            locationManager.stopMonitoringSignificantLocationChanges()
        }
    }
    
    private func userDefaultsForMetadata() -> UserDefaults {
        return UserDefaults(suiteName: "com.mumble.mburger.metadata") ?? UserDefaults.standard
    }
}

extension MBMetadataManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            currentLocation = lastLocation.coordinate
            updateMetadata()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}
