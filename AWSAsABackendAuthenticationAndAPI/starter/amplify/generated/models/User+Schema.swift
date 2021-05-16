// swiftlint:disable all
import Amplify
import Foundation

extension User {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case username
    case sub
    case postcode
    case createdAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let user = User.keys
    
    model.authRules = [
      rule(allow: .owner, ownerField: "owner", identityClaim: "cognito:username", operations: [.create, .update, .delete, .read])
    ]
    
    model.pluralName = "Users"
    
    model.fields(
      .id(),
      .field(user.username, is: .required, ofType: .string),
      .field(user.sub, is: .required, ofType: .string),
      .field(user.postcode, is: .optional, ofType: .string),
      .field(user.createdAt, is: .optional, ofType: .dateTime)
    )
    }
}