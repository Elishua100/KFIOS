/// Copyright (c) 2020 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import Amplify
import AmplifyPlugins


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var logger = Logger()
  let userSession = UserSession()

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    // Setup user
    let authenticationService = AuthenticationService(userSession: userSession)
    do {
      try Amplify.add(plugin: AWSCognitoAuthPlugin())
      try Amplify.add(plugin: AWSAPIPlugin(modelRegistration:AmplifyModels()))

      try Amplify.configure()

      #if DEBUG
      Amplify.Logging.logLevel = .debug
      #else
      Amplify.Logging.logLevel = .error
      #endif
    } catch {
      print("Error initializing Amplify. \(error)")
    }


    // Handle Authentication
    authenticationService.checkAuthSession()

    // Theme setup
    UINavigationBar.appearance().backgroundColor = .backgroundColor
    UITableView.appearance().backgroundColor = .backgroundColor
    UITableView.appearance().separatorStyle = .none
    UITableViewCell.appearance().backgroundColor = .backgroundColor
    UITableViewCell.appearance().selectionStyle = .none

    // Listen to auth changes
    _ = Amplify.Hub.listen(to: .auth) { payload in
      switch payload.eventName {
      case HubPayload.EventName.Auth.sessionExpired:
        authenticationService.checkAuthSession()
      default:
        break
      }
    }
    
    return true
  }

  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }
    
}

