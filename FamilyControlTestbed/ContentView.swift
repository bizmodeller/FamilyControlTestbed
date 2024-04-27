//
//  ContentView.swift
//  FamilyControlTestbed
//

import SwiftUI
import FamilyControls
import DeviceActivity

extension Date {
    var startOfDay: Date {
        return Calendar.current.nextDate(after: self-60.0*60.0*24.0, matching: DateComponents(hour: 0, minute: 0), matchingPolicy: .nextTimePreservingSmallerComponents)!
    }
}

extension UIViewController{
    
    public func showAlertMessage(title: String, message: String){
        
        let alertMessagePopUpBox = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        
        alertMessagePopUpBox.addAction(okButton)
        self.present(alertMessagePopUpBox, animated: true)
    }
}

struct ContentView: View {
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isPickerPresented = false
    @State private var selection = FamilyActivitySelection()
    
    // TODO: cha\nge to start at midnight
    var filter_children = DeviceActivityFilter(
        segment: . hourly(during: DateInterval(start: Date().startOfDay, end: Date())),
        users: .children,
        devices: .all )
    
    var filter_all = DeviceActivityFilter(
        segment: . hourly(during: DateInterval(start: Date().startOfDay, end: Date())),
        users: .all,
        devices: .all )
    
    var body: some View {
        NavigationStack {
            TabView {
                VStack {
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    Text("It's just that easy")
                    Button("Authorize Child") {
                        Task {
                            do {
                                try await AuthorizationCenter.shared.requestAuthorization(for: .child)
                                print("requestAuthorization success")
                                switch AuthorizationCenter.shared.authorizationStatus {
                                case .notDetermined:
                                    print("not determined")
                                case .denied:
                                    print("denied")
                                case .approved:
                                    print("approved")
                                @unknown default:
                                    break
                                }
                                alertMessage = "Authorize child successful " + String(describing: AuthorizationCenter.shared.authorizationStatus)
                                showAlert = true
                                
                            } catch {
                                alertMessage = "Authorize child failed: " + error.localizedDescription
                                showAlert = true
                            }
                        }
                    }
                    .alert(String(alertMessage), isPresented: $showAlert) {
                        Button("OK") { }
                    }
                }
                .padding()
                .tabItem {
                    Label("Authorization", systemImage: "lock")
                }
                VStack {
                    Text(".children activity")
                    DeviceActivityReport(.init("totalActivity"), filter: filter_children)
                    Text(".all activity")
                    DeviceActivityReport(.init("totalActivity"), filter: filter_all)
                }
                .tabItem {
                    Label("Activity", systemImage: "chart.xyaxis.line")
                }
                  VStack {
                        Button("Present FamilyActivityPicker") { isPickerPresented = true }
                               .familyActivityPicker(isPresented: $isPickerPresented,
                                                     selection: $selection)
                  }
                  .tabItem {
                      Label("Picker", systemImage: "apps.iphone.badge.plus")
                  }
            }
        }
    }
}
