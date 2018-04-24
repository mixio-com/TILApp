import Vapor

struct CategoriesController: RouteCollection {

    func boot(router: Router) throws {

        let categoriesRoute = router.grouped("api", "categories")

        categoriesRoute.post(Category.self, use: createHandler)
        categoriesRoute.get(use: getAllHandler)
        categoriesRoute.get(Category.parameter, use: getHandler)
        categoriesRoute.put(Category.parameter, use: updateHandler)

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

}
