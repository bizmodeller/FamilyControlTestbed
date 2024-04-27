//
//  FamilyControlReportTestbed.swift
//  FamilyControlReportTestbed


import DeviceActivity
import SwiftUI

@main
struct FamilyControlReportTestbed: DeviceActivityReportExtension {
    var body: some DeviceActivityReportScene {
        // Create a report for each DeviceActivityReport.Context that your app supports.
        TotalActivityReport { totalActivity in
            TotalActivityView(activities: totalActivity)
        }
        // Add more reports here...
    }
}
