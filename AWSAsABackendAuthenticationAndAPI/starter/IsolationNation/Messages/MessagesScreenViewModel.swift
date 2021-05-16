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

struct MessageModel: Identifiable, Equatable {
  let id: String
  let body: String
  let authorName: String
  let messageThreadId: String?
  let createdAt: Date?
}

struct CreateMessageInput {
  var body: String
  var messageThreadId: String
}

enum MessagesScreenViewModelAction {
  case fetchMessages
  case subscribe
  case addMessage(CreateMessageInput)
}

final class MessagesScreenViewModel: ObservableObject {
  let userSession: UserSession
  let threadID: String
  let logger: Logger?

  var messageList: [MessageModel]

  // MARK: - Publishers
  @Published var messageListState: Loading<[MessageModel]>

  init(userSession: UserSession, threadID: String) {
    self.userSession = userSession
    self.threadID = threadID
    messageList = []
    messageListState = .loading([])
    logger = Logger()
  }

  init(userSession: UserSession, threadID: String, messages: [MessageModel]) {
    logger = nil
    self.userSession = userSession
    self.threadID = threadID
    messageList = messages
    messageListState = .loaded(messages)
  }

  // MARK: Actions

  func perform(action: MessagesScreenViewModelAction) {
    switch action {
    case .fetchMessages:
      fetchMessages()
    case .subscribe:
      subscribe()
    case .addMessage(let input):
      addMessage(input: input)
    }
  }

  // MARK: Action handlers

  private func fetchMessages() {
    messageList = [
      MessageModel(
        id: "0",
        body: "Help Needed. Can somebody buy me some groceries please?",
        authorName: "Lizzie",
        messageThreadId: "0",
        createdAt: Date()
      ),
      MessageModel(
        id: "1",
        body: "Dog walking request please",
        authorName: "Charlie",
        messageThreadId: "0",
        createdAt: Date()
      ),
      MessageModel(
        id: "2",
        body: "Anyone have any loo roll, I'm out!",
        authorName: "Andy",
        messageThreadId: "0",
        createdAt: Date()
      )
    ]
    messageListState = .loaded(messageList)
  }

  private func addMessage(input: CreateMessageInput) {
    // To implement
  }

  private func subscribe() {
    // To implement
  }
}
