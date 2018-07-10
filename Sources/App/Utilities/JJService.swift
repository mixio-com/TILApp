//
//  JJService.swift
//  App
//
//  Created by jj on 09/07/2018.
//
import Vapor

struct JJService: ServiceType {
    public static func makeService(for container: Container) throws -> JJService {
        return .init()
    }
}
extension JJService: Service {
    func sayHello() -> String {
        return "Hi! JJ Service speaking. What is your question?"
    }
}
