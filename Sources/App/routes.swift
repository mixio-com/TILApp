import Routing
import Vapor
import Fluent

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {

    router.get("api", "acronyms") { req -> Future<[Acronym]> in

            return Acronym.query(on: req).all()

    }

    router.post("api", "acronyms") { req -> Future<Acronym> in

        return try req.content.decode(Acronym.self).flatMap(to: Acronym.self) { acronym in

            return acronym.save(on: req)

        }

    }

    router.get("api", "acronyms", Acronym.parameter) { req -> Future<Acronym> in

        return try req.parameters.next(Acronym.self)

    }

    router.put("api", "acronyms", Acronym.parameter) { req -> Future<Acronym> in

        return try flatMap(to: Acronym.self, req.parameters.next(Acronym.self), req.content.decode(Acronym.self)) { acronym, updatedAcronym in

            acronym.short = updatedAcronym.short
            acronym.long = updatedAcronym.long
            return acronym.save(on: req)

        }

    }

    router.delete("api", "acronyms", Acronym.parameter) { req -> Future<HTTPStatus> in

        return try req.parameters.next(Acronym.self).flatMap(to: HTTPStatus.self) { acronym in

            return acronym.delete(on:req).transform(to: HTTPStatus.noContent)
        }

    }

    router.get("api", "acronyms", "search") { req -> Future<[Acronym]> in

        guard let searchTerm = req.query[String.self, at: "term"] else {
            throw Abort(.badRequest)
        }

        return try Acronym.query(on: req).filter(\.short == searchTerm).all()

    }

    router.get("api", "acronyms", "fullsearch") { req -> Future<[Acronym]> in

        guard let searchTerm = req.query[String.self, at: "term"] else {
            throw Abort(.badRequest)
        }

        return try Acronym.query(on: req).group(.or) { or in

            try or.filter(\Acronym.short ~~ [searchTerm, "ASAP"])
            try or.filter(\Acronym.long ~~ [searchTerm])

        }.all()
    }

    router.get("api", "acronyms", "first") { req -> Future<Acronym> in

        return try Acronym.query(on: req).sort(\.id, .ascending).first().map(to: Acronym.self) { acronym in

            guard let acronym = acronym else {
                throw Abort(.notFound)
            }

            return acronym

        }

    }

    router.get("api", "acronyms", "sorted") { req -> Future<[Acronym]> in

        return try Acronym.query(on: req).sort(\.short, .ascending).all()

    }
}
