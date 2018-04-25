import Vapor

struct CategoriesController: RouteCollection {

    func boot(router: Router) throws {

        let categoriesRoutes = router.grouped("api", "categories")

        categoriesRoutes.post(Category.self, use: createHandler)
        categoriesRoutes.get(use: getAllHandler)
        categoriesRoutes.get(Category.parameter, use: getHandler)
        categoriesRoutes.put(Category.parameter, use: updateHandler)
        categoriesRoutes.get(Category.parameter, "acronyms", use: getAcronymsHandler)

    }

    func createHandler(_ req: Request, category: Category) throws -> Future<Category> {

        return category.save(on: req)

    }

    func getAllHandler(_ req: Request) throws -> Future<[Category]> {

        return Category.query(on: req).all()

    }

    func getHandler(_ req: Request) throws -> Future<Category> {

        return try req.parameters.next(Category.self)

    }

    func updateHandler(_ req: Request) throws -> Future<Category> {

        return try flatMap(to: Category.self, req.parameters.next(Category.self), req.content.decode(Category.self)) { category, updatedCategory in

            category.name = updatedCategory.name

            return category.save(on: req)

        }

    }

    func getAcronymsHandler(_ req: Request) throws -> Future<[Acronym]> {

        return try req.parameters.next(Category.self).flatMap(to: [Acronym].self) { category in

            try category.acronyms.query(on: req).all()

        }

    }

}
