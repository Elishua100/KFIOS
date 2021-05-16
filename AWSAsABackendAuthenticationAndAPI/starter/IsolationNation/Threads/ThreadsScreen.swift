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

import SwiftUI

struct ThreadsScreen: View {
  @EnvironmentObject var viewModelFactory: ViewModelFactory
  @EnvironmentObject var userSession: UserSession
  @ObservedObject private(set) var model: ThreadsScreenViewModel

  struct SignOutButton: View {
    let userSession: UserSession

    var body: some View {
      let rootView = RootView(
        userSession: userSession,
        viewModelFactory: ViewModelFactory(userSession: userSession)
      )
      return NavigationLink(destination: rootView) {
        Button(action: signOut) {
          Text("Sign Out")
        }
      }
    }

    func signOut() {
      let authService = AuthenticationService(userSession: userSession)
      authService.signOut()
    }
  }

  var body: some View {
    Loadable(loadingState: model.threadListState) { threadList in
      List(threadList) { thread in
        VStack(alignment: .leading) {
          NavigationLink(
            destination: MessagesScreen(model: viewModelFactory.getOrCreateMessagesScreenViewModel(for: thread.id))
          ) {
            Text(thread.name)
          }
        }
      }
      .listStyle(GroupedListStyle())
      .navigationBarTitle(Text("Locations"))
      .navigationBarItems(trailing: SignOutButton(userSession: userSession))
    }
  }
}

struct ThreadsScreen_Previews: PreviewProvider {
  static var previews: some View {
    let sampleData = [
      ThreadModel(id: "0", name: "SW1A")
    ]

    return ThreadsScreen(model:
      ThreadsScreenViewModel(userSession: UserSession(), threads: sampleData)
    )
      .environmentObject(UserSession())
      .environmentObject(ViewModelFactory(userSession: UserSession()))
  }
}
