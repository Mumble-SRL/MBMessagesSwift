![Test Status](https://img.shields.io/badge/documentation-100%25-brightgreen.svg)
![License: MIT](https://img.shields.io/badge/pod-v1.0.2-blue.svg)
[![CocoaPods](https://img.shields.io/badge/License-Apache%202.0-yellow.svg)](LICENSE)

# MBMessagesSwift

MBMessagesSwift is a plugin libary for [MBurger](https://mburger.cloud), that lets you display in app messages and manage push notifications in your app. The minimum deployment target for the library is iOS 11.0.

# Installation

# Installation with CocoaPods

CocoaPods is a dependency manager for iOS, which automates and simplifies the process of using 3rd-party libraries in your projects. You can install CocoaPods with the following command:

```ruby
$ gem install cocoapods
```

To integrate the MBurgerSwift into your Xcode project using CocoaPods, specify it in your Podfile:

```ruby
platform :ios, '10.0'

target 'TargetName' do
    pod 'MBMessagesSwift'
end
```

If you use Swift rememember to add `use_frameworks!` before the pod declaration.


Then, run the following command:

```
$ pod install
```

CocoaPods is the preferred methot to install the library.

# Manual installation

To install the library manually drag and drop the folder `MBMessages` to your project structure in XCode. 

Note that `MBMessages` has `MBurgerSwift (1.0.5)` and `MPushSwift (0.2.12)` as dependencies, so you have to install also those libraries.

# Initialization

To initialize the SDK you have to add the `MBMessages` class to the array of plugins of `MBurger`.

```swift
import MBurgerSwift
import MBMessagesSwift

...

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

    MBManager.shared.apiToken = "YOUR_API_TOKEN"
    MBManager.shared.plugins = [MBMessages()]
        
    return true
}
```

Then you have to tell MBManager.shared that the app has been opened with `MBManager.shared.applicationDidFinishLaunchingWithOptions(launchOptions: launchOptions)`, this will trigger all the startup actions of the MBurger plugins. Once you've done this in app messages will be fetched automatically at the startup of the application and showed, if they need to be showed.


```swift
...

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

    MBManager.shared.apiToken = "YOUR_API_TOKEN"
    MBManager.shared.plugins = [MBMessages()]
        
    MBManager.shared.applicationDidFinishLaunchingWithOptions(launchOptions: launchOptions)

    return true
}
```

## Parameters of initialization

You can set a couples of parameters when initializing the `MBMessages` plugin:

```swift
let messagesPlugin = MBMessages(delegate: [the delegate],
                                viewDelegate: [view delegate],
                                styleDelegate: [style delegate],
                                messagesDelay: 1
                                debug: true)

```

- **messagesDelay**: it's the time after which the messages will be displayed once fetched
- **debug**: if this is set to `true`, all the message returned by the server will be displayed, if this is set to `false` a message will appear only once for app installation. This is `false` by default
- **debug**: the delegate will receive a call if the fetch of the messages fails, with the error that caused the fail, see [MBMessagesDelegate](#MBMessagesDelegate) for more details.
- **viewDelegate**: the view delegates will receive calls when views of messages are showed or hidden, it will also receives a call when the button of the views will be touched, so you need to implement this protocol if you want to open an in-app link from an in app message. See [MBInAppMessageViewDelegate](#MBInAppMessageViewDelegate) for a detailed description of the protocol.
- **styleDelegate**: you can use this protocol to specify colors and fonts of the in app messages. See [Stylize in app messages](#Stylizeinappmessages) for more details

# Stylize in app messages

### MBMessagesDelegate

Implement this protocol if you want to receive a function call when in app messages view are showed or hidden. You will need to use this protocol also if you want to responsd to a user tapping on buttons on in app messages view.

`viewWillAppear` and `viewDidAppear` are called when the view is showed, `viewWillDisappear` and `viewDidDisappear` when it's hidden.

```swift
func viewWillAppear(view: MBInAppMessageView)
func viewDidAppear(view: MBInAppMessageView)
func viewWillDisappear(view: MBInAppMessageView)
func viewDidDisappear(view: MBInAppMessageView)
```

To respond to a user tapping on a button you have to implement `func buttonPressed(view: MBInAppMessageView, button: MBInAppMessageButton)`, here's an example:

```swift
func buttonPressed(view: MBInAppMessageView, button: MBInAppMessageButton) {
    let linkType = button.linkType
    if linkType == .link && button.link.hasPrefix("http") {
        if let url = URL(string: button.link) {
            //Open url
        }
    } else {
        // Open in app link (button.link)
    }
}
```


### MBMessagesDelegate

Implement this protocol if you want to receives a call when the fetches of the message fails from the server:

```swift
func inAppMessageCheckFailed(sender: MBMessages, error: Error?)
```


# Push notifications