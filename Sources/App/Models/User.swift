import Foundation
import Vapor
import FluentPostgreSQL

final class User: Codable {

    var id: UUID?
    var name: String
    var username: String
    var password: String

    init(name: String, username: String, password: String) {
        self.name = name
        self.username = username
        self.password = password
    }

}

extension User: PostgreSQLUUIDModel {}
extension User: Content {}
extension User: Parameter {}

extension User: Migration {
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
            try builder.addIndex(to: \.username, isUnique: true)
        }
    }
}

extension User {

    var acronyms: Children<User, Acronym> {

        return children(\.userID)

    }

}
