/// Copyright (c) 2018 Razeware LLC
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
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

@testable import App
import FluentPostgreSQL
import Crypto

extension User {
    static func create(name: String = "Luke", username: String? = nil, on connection: PostgreSQLConnection) throws -> User {
        var createUsername: String
        if let suppliedUsername = username {
            createUsername = suppliedUsername
        } else {
            createUsername = UUID().uuidString
        }
        let password = try BCrypt.hash("password")
        let user = User(name: name, username: createUsername, password: password)
        return try user.save(on: connection).wait()
    }
}

extension Acronym {
    static func create(short: String = "TIL", long: String = "Today I Learned", user: User? = nil, on connection: PostgreSQLConnection) throws -> Acronym {
        var acronymsUser = user

        if acronymsUser == nil {
            acronymsUser = try User.create(on: connection)
        }

        let acronym = Acronym(short: short, long: long, userID: acronymsUser!.id!)
        return try acronym.save(on: connection).wait()
    }
}

extension App.Category {
    static func create(name: String = "Random", on connection: PostgreSQLConnection) throws -> App.Category {
        let category = Category(name: name)
        return try category.save(on: connection).wait()
    }
}
