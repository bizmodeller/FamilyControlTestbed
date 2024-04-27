#  Screen Time API Test Bed

## Introduction

This is a test bed app to replicate issues with Apple's Screentime API.  Specifically, we are seeing issues with parent / child screen time data sharing and other intermittent issues.  The Parent App should be able to see the screen time activity and applications from the child's device.  However, even when parent and child are hosted in the same iCloud Family, in our tests, we see that the Parent instnace of the app does not see any screen time activity from the child and sees their own applications in the FamilyActivityPicker, instead of the child's list.

Separately, we also note that the DeviceActivityReport does not render reliably, sometimes rendering a blank screen; flicking between the tabs seems to get it to render again.

Whilst the results below use iOS 17.5 beta 3 for the parent app, we saw very similar behaviour with iOS 17.4.1 on the parent app.  The only difference was that the FamilyActivityPicker shows no apps, only categories in the testing configuration.

For the avoidance of doubt, we assume that parent instances of the app should NOT call `AuthorizationCenter.shared.requestAuthorization(for: .individual)`, and that only the child instance of the app should call `AuthorizationCenter.shared.requestAuthorization(for: .child)`.

## Scope

Covers:

- Child Authorization
- FamilyActivityPicker
- DeviceActivityReport

## Testing Setup

parent:
- iPhone 17.5 beta 3
- No `AuthorizationCenter` call
- Screen Time enabled in Settings and can see Child's activity in the out of the box Apple Screentime app

child:
- iPadOS 17.4.1
- `AuthorizationCenter.shared.requestAuthorization(for: .child)` call
- Screen Time enabled in Settings and configured to Share with other devices.  Activity can be seen in the child and parent's out of the box Apple Screentime app.

## Results

### On Child Device:

- report filtered to .children shows the child's activity
- report filtered to .all shows the child's activity (identical to .children)
- picker shows child's apps

### On Parent Device:

- report filtered to .children shows nothing
- report filtered to .all shows the parent's activity
- picker shows parent's app

