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
import Combine

struct KeyboardAdaptive: ViewModifier {
  @State var bottomPadding: CGFloat = 0

  func body(content: Content) -> some View {
    GeometryReader { geometry in
      content
        .padding(.bottom, bottomPadding)
        .onReceive(Publishers.keyboardHeight) { keyboardInfo in
          bottomPadding = max(0, keyboardInfo.keyboardHeight - geometry.safeAreaInsets.bottom)
        }
        .animation(.easeInOut(duration: 0.25))
    }
  }
}

struct KeyboardInfo {
  let keyboardHeight: CGFloat
  let animationCurve: UIView.AnimationCurve
  let animationDuration: TimeInterval
}

extension View {
  func keyboardAdaptive() -> some View {
    ModifiedContent(content: self, modifier: KeyboardAdaptive())
  }
}

extension Publishers {
  static var keyboardHeight: AnyPublisher<KeyboardInfo, Never> {
    let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
      .map {
        KeyboardInfo(
          keyboardHeight: $0.keyboardHeight,
          animationCurve: $0.animationCurve,
          animationDuration: $0.animatinDuration
        )
      }

    let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
      .map {
        KeyboardInfo(
          keyboardHeight: 0,
          animationCurve: $0.animationCurve,
          animationDuration: $0.animatinDuration
        )
      }

    return MergeMany(willShow, willHide)
      .eraseToAnyPublisher()
  }
}

extension Notification {
  var keyboardHeight: CGFloat {
    (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
  }

  var animationCurve: UIView.AnimationCurve {
    userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UIView.AnimationCurve ?? .easeInOut
  }

  var animatinDuration: TimeInterval {
    userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? Double(0.16)
  }
}

// From https://stackoverflow.com/a/14135456/6870041
extension UIResponder {
  static var currentFirstResponder: UIResponder? {
    privateCurrentFirstResponder = nil
    UIApplication.shared.sendAction(#selector(UIResponder.findFirstResponder(_:)), to: nil, from: nil, for: nil)
    return privateCurrentFirstResponder
  }

  static weak var privateCurrentFirstResponder: UIResponder?

  @objc func findFirstResponder(_ sender: Any) {
    UIResponder.privateCurrentFirstResponder = self
  }

  var globalFrame: CGRect? {
    guard let view = self as? UIView else { return nil }
    return view.superview?.convert(view.frame, to: nil)
  }
}
