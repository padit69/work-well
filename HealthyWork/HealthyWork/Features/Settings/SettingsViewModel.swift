//
//  SettingsViewModel.swift
//  HealthyWork
//

import Foundation
import SwiftUI
import UserNotifications

@Observable
final class SettingsViewModel {
    var preferences: UserPreferences
    /// True when notification authorization is .authorized (or .provisional). Used to show Request button only when needed.
    var notificationAuthorized: Bool = false

    init() {
        self.preferences = PreferencesService.load()
    }

    func saveAndReschedule() {
        PreferencesService.save(preferences)
        ReminderSchedulingService.rescheduleAll(preferences: preferences)
    }

    func refreshNotificationStatus() {
        ReminderSchedulingService.getAuthorizationStatus { [weak self] status in
            self?.notificationAuthorized = (status == .authorized || status == .provisional)
        }
    }

    func requestNotificationPermission() {
        ReminderSchedulingService.requestAuthorization { [weak self] _ in
            self?.refreshNotificationStatus()
        }
    }
}
