# SpaceShuttleLocator

Description:

An app with Google Map view and a space shuttle with continuously updating its location on the Map. When user taps on the shuttle icon it shows the current City Name in callout view.


# Building SpaceShuttleLocator:

Step 1: Get the latest version of Xcode

To build a project using the Google Maps SDK for iOS, you need version 6.3 or later of Xcode.

# CocoaPods

Step 2: Get CocoaPods

CocoaPods is an open source dependency manager for Swift and Objective-C Cocoa projects.
If you don't already have the CocoaPods tool, install it on OS X by running the following
command from the terminal. 

$ sudo gem install cocoapods

For details, see the "https://guides.cocoapods.org/using/getting-started.html".
The Google Maps SDK for iOS is available as a CocoaPods pod. 

Step 3: Install the Google SDK using CocoaPods

1. Open a terminal and go to the directory containing the Podfile:
$ cd <path-to-project>

2. Run the pod install command. This will install the APIs specified in the Podfile, along with any dependencies they may have.
$ pod install

3. Close Xcode

# To Run SpaceShuttleLocator:

1. Open Project, and then open (double-click) your project's .xcworkspace file to launch Xcode. 
2. From this time onwards, you must use the .xcworkspace file to open the project.

Step 4: Run the project.



Features:

- Shows Space shuttle current location.
- Action button given to animate the Map with shuttle in Callout view's' visible area. (If shuttle goes out of Callout View Visible Area)
- When user taps on the shuttle icon it shows the current City Name in the callout view.


