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
import Combine

enum SignUpOrSignInViewModelAction {
  case selectSignIn
  case selectSignUp
  case signIn(SignInInput)
  case signUp(SignUpInput)
  case confirmUser(ConfirmUserInput)
}

struct SignInInput {
  var username: String
  var password: String
}

struct SignUpInput {
  var username: String
  var password: String
  var email: String
}

struct ConfirmUserInput {
  var username: String
  var password: String
  var confirmCode: String
}

final class SignUpOrSignInViewModel: ObservableObject {
  @Published var state = AuthenticationState.startingSignIn

  let authService: AuthenticationService
  let logger = Logger()

  var cancellable: AnyCancellable?

  init(userSession: UserSession) {
    authService = AuthenticationService(userSession: userSession)
  }

  // MARK: Actions

  func perform(action: SignUpOrSignInViewModelAction) {
    switch action {
    case .selectSignIn:
      state = .startingSignIn
    case .selectSignUp:
      state = .startingSignUp
    case .signIn(let input):
      signIn(as: input.username, identifiedBy: input.password)
    case .signUp(let input):
      signUp(as: input.username, identifiedBy: input.password, with: input.email)
    case .confirmUser(let input):
      confirmSignUp(for: input.username, with: input.password, confirmedBy: input.confirmCode)
    }
  }

  // MARK: Action handlers

  private func signIn(as username: String, identifiedBy password: String) {
    cancellable = authService.signIn(as: username, identifiedBy: password)
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: asyncCompletionErrorHandler) { state in
        self.state = state
      }
  }

  private func signUp(as username: String, identifiedBy password: String, with email: String) {
    cancellable = authService.signUp(as: username, identifiedBy: password, with: email)
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: asyncCompletionErrorHandler) { state in
        self.state = state
      }
  }

  func confirmSignUp(for username: String, with password: String, confirmedBy confirmationCode: String) {
    cancellable = authService.confirmSignUp(for: username, with: password, confirmedBy: confirmationCode)
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: asyncCompletionErrorHandler) { state in
        self.state = state
      }
  }

  private func asyncCompletionErrorHandler(completion: Subscribers.Completion<Error>) {
    switch completion {
    case .failure(let error):
      logger.logError(error)
      state = .errored(error)
      DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        self.state = .startingSignIn
      }
    case .finished: ()
    }
  }
}
