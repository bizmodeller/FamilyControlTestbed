//
//  TotalActivityReport.swift
//  FamilyControlReportTestbed
//


import DeviceActivity
import ManagedSettings
import SwiftUI

extension DeviceActivityReport.Context {
    // If your app initializes a DeviceActivityReport with this context, then the system will use
    // your extension's corresponding DeviceActivityReportScene to render the contents of the
    // report.
    static let totalActivity = Self("totalActivity")
}

struct AppReport: Identifiable {
    
    var id: String
    var name: String
    var dateInterval: DateInterval
    var duration: TimeInterval
    var user: String
    var applicationToken: ApplicationToken?

}


struct DeviceActivity {
    
    let duration: TimeInterval    
    let apps: [AppReport]
    let debug: String
    
}

struct TotalActivityReport: DeviceActivityReportScene {
    
    // Define which context your scene will represent.
    let context: DeviceActivityReport.Context = .totalActivity
    
    // Define the custom configuration and the resulting view for this report.
    let content: (DeviceActivity) -> TotalActivityView
    
    func makeConfiguration(representing data: DeviceActivityResults<DeviceActivityData>) async -> DeviceActivity {
                
        var list: [AppReport] = []
        
        let totalActivityDuration = await data.flatMap { $0.activitySegments }.reduce(0, {
            $0 + $1.totalActivityDuration
        })
        
        var count = 0
        var debug = "debug"
        for await _data in data {
            for await activity in _data.activitySegments {
                for await category in activity.categories {
                    for await app in category.applications {
                        count += 1
                        let appName = (app.application.localizedDisplayName ?? "nil")
                        let bundle = (app.application.bundleIdentifier ?? "nil")
                        let duration = app.totalActivityDuration
                        let appToken = app.application.token
                        let interval = activity.dateInterval
                        let user = (_data.user.nameComponents?.givenName ?? "") + String(count)
                        let app = AppReport(id: String(count), name: appName, dateInterval: interval , duration: app.totalActivityDuration, user: user, applicationToken: appToken)
                       
                        list.append(app)
                    }
                }
            }
        }

        return DeviceActivity(duration: totalActivityDuration, apps: list, debug: debug)
    }
    
}
