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

struct SetPostcodeView: View {
  @EnvironmentObject var user: UserSession
  @State var postcode: String = ""

  var model: HomeScreenViewModel

  var body: some View {
    VStack {
      Text("Save the Nation in Isolation!")
        .italic()
        .padding(.bottom)
      Text(
        """
        This app puts you in touch with those \
        in your neighborhood so you can help \
        each other out. Please let us know your \
        postcode so we can add you to the correct thread.
        """)
        .font(.body)
        .padding(.bottom)
      TextField("Enter your postcode", text: $postcode)
        .padding(.trailing)
        .textFieldStyle(RoundedBorderTextFieldStyle())
      Button(
        action: {
          let sanitisedPostcode = postcode
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .uppercased()
          model.perform(action: .addPostCode(sanitisedPostcode))
        },
        label: {
          Text("Update")
        }
      )
        .disabled(!postcode
          .trimmingCharacters(in: .whitespacesAndNewlines)
          .uppercased()
          .isValidPostcode()
      )
    }
    .padding()
    .keyboardAdaptive()
  }
}

struct SetPostcodeView_Previews: PreviewProvider {
  static var previews: some View {
    let user = UserModel(id: "0", username: "Bob", sub: "0", postcode: "")

    return SetPostcodeView(model: HomeScreenViewModel(userID: "", user: user))
      .environmentObject(UserSession())
  }
}
