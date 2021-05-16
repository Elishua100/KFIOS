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

struct SignInView: View {
  @ObservedObject private(set) var model: SignUpOrSignInViewModel

  @State var input = SignInInput(username: "", password: "")

  var body: some View {
    VStack(alignment: .leading) {
      Text("Sign in to your account")
        .font(.largeTitle)
      Form {
        Section {
          Text("Username *")
            .font(.subheadline)
          TextField("Enter your username", text: $input.username)
          Text("Password *")
            .font(.subheadline)
          SecureField("Enter your password", text: $input.password)
        }
        Section {
          PrimaryButton(
            action: {
              model.perform(action: .signIn(input))
            }, label: {
              Text("Sign In")
            }
          )
            .disabled(input.username.count < 3 || input.password.count < 8)
        }
        Section {
          HStack {
            Text("No account? ")
            Button(
              action: {
                model.perform(action: .selectSignUp)
              }, label: {
                Text("Sign Up")
              }
            )
          }
        }
      }
    }
    .padding()
  }
}

struct SignInView_Previews: PreviewProvider {
  static var previews: some View {
    SignInView(model: SignUpOrSignInViewModel(userSession: UserSession()))
  }
}
