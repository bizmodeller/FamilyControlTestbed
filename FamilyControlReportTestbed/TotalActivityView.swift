//
//  TotalActivityView.swift
//  FamilyControlReportTestbed
//


import SwiftUI
import FamilyControls

extension TimeInterval {
    
    func toString() -> String {
        let time = NSInteger(self)
        
        let ms = Int((self.truncatingRemainder(dividingBy: 1)) * 1000)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        
        return String(format: "%0.2dh%0.2d",hours,minutes)
    }
    
}


struct ListItem: View {
    
    private let app: AppReport
    
    init(app: AppReport) {
        self.app = app
    }
    
    var body: some View {
        HStack {
            if let unwrapped = app.applicationToken {
                Label(unwrapped).labelStyle(.iconOnly)
            }
            VStack {
                Text(app.name)
                Text(app.user)
                Text(app.dateInterval.start.description + " -> " + app.dateInterval.end.description)
            }
            
            Spacer()
            Spacer()
            Text(app.duration.toString().replacingOccurrences(of: ":", with: "h"))
        }
    }
}

struct TotalActivityView: View {
    var activities: DeviceActivity
    
    var body: some View {
        VStack {
           Text(activities.debug)
            List(activities.apps) { app in
                ListItem(app: app)
            }.frame(minHeight: 300, maxHeight: 300)
        }
    
    }
}
