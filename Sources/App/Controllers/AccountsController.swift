//
//  AccountController.swift
//  App
//
//  Created by jj on 02/07/2018.
//

import Foundation
import FluentPostgreSQL
import Vapor

struct AccountsController: RouteCollection {

    func boot(router: Router) throws {
        let accountRouter = router.grouped("account")
        accountRouter.get("quicky", use:quickTest)
        accountRouter.get("jjservice", use: jjService)
    }

    func quickTest(_ req: Request) throws -> Future<[Account]> {
        //return Account.query(on: req).filter(\.paid, .equal, true).all()
        return Account.query(on: req).filter(\.paid == true).all()
    }
    func jjService(_ req: Request) throws -> String {
        let jjService = try req.make(JJService.self)
        let string = jjService.sayHello()
        return string
    }
}
