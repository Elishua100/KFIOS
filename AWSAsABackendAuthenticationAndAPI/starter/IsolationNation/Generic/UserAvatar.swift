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

enum AvatarColors: CaseIterable {
  case red
  case orange
  case yellow
  case teal

  func color() -> Color {
    switch self {
    case .red:
      return Color(UIColor.systemRed)
    case .orange:
      return Color(UIColor.systemOrange)
    case .yellow:
      return Color(UIColor.systemYellow)
    case .teal:
      return Color(UIColor.systemTeal)
    }
  }
}

struct UserAvatar: View {
  let username: String

  func colorForUser() -> Color {
    guard let firstLetterInASCII = username.unicodeScalars.first?.value else {
      return AvatarColors.allCases.randomElement()?.color() ?? AvatarColors.red.color()
    }

    let index = Int(firstLetterInASCII) % AvatarColors.allCases.count
    return AvatarColors.allCases[index].color()
  }

  func letterForAvatar() -> String {
    if let char = username.first {
      return String(char)
    }
    return ""
  }

  var body: some View {
    GeometryReader { geometry in
      ZStack {
        Rectangle()
          .fill(colorForUser())
          .cornerRadius(geometry.size.width / 8)
        Text(letterForAvatar())
          .font(.system(size: geometry.size.width / 2))
      }
      .shadow(radius: geometry.size.width / 20.0)
    }
  }
}

struct UserAvatar_Previews: PreviewProvider {
  static var previews: some View {
    UserAvatar(username: "Bob")
  }
}
