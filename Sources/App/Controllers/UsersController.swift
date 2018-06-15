import Vapor
import Crypto

struct UsersController: RouteCollection {

    func boot(router: Router) throws {
        let usersRoutes = router.grouped("api", "users")
        usersRoutes.post(User.self, use: createHandler)
        usersRoutes.get(use: getAllHandler)
        usersRoutes.get(User.parameter, use: getHandler)
        usersRoutes.get(User.parameter, "acronyms", use: getAcronymsHandler)
        usersRoutes.delete(User.parameter, use: deleteHandler)
        usersRoutes.put(User.parameter, use: updateHandler)
    }

    func createHandler(_ req: Request, user: User) throws -> Future<User.Public> {
        user.password = try BCrypt.hash(user.password)
        return user.save(on: req).convertToPublic()
    }

    func getAllHandler(_ req: Request) throws -> Future<[User.Public]> {
        return User.query(on: req).all().map(to: [User.Public].self) { users in
            return users.map { $0.convertToPublic() }
        }
    }

    func getHandler(_ req: Request) throws -> Future<User.Public> {
        return try req.parameters.next(User.self).convertToPublic()
    }

    func getAcronymsHandler(_ req: Request) throws -> Future<[Acronym]> {
        return try req.parameters.next(User.self).flatMap(to: [Acronym].self) { user in
            try user.acronyms.query(on: req).all()
        }
    }

    func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(User.self).flatMap(to: HTTPStatus.self) { user in
            return user.delete(on:req).transform(to: HTTPStatus.noContent)
        }
    }

    func updateHandler(_ req: Request) throws -> Future<User.Public> {
        return try flatMap(to: User.Public.self, req.parameters.next(User.self), req.content.decode(User.self)) { user, updatedUser in
            user.name = updatedUser.name
            user.username = updatedUser.username
            return user.save(on: req).convertToPublic()
        }
    }

}
