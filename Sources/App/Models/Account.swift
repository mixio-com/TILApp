//
//  Account.swift
//  App
//
//  Created by jj on 02/07/2018.
//

import Foundation
import Vapor
import FluentPostgreSQL

struct Account: Content, Model, PostgreSQLTable {
    typealias Database = PostgreSQLDatabase
    typealias ID = Int
    static var idKey : WritableKeyPath<Account, Int?> = \Account.accountid
    static let entity = "account"
//    static var sqlTableIdentifierString: String {
//        return entity
//    }
    static var sqlTableIdentifierString = entity

    var accountid: Int?
    var paid: Bool



}
