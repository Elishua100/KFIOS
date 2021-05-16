// swiftlint:disable all
import Amplify
import Foundation

public struct User: Model {
  public let id: String
  public var username: String
  public var sub: String
  public var postcode: String?
  public var createdAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      username: String,
      sub: String,
      postcode: String? = nil,
      createdAt: Temporal.DateTime? = nil) {
      self.id = id
      self.username = username
      self.sub = sub
      self.postcode = postcode
      self.createdAt = createdAt
  }
}