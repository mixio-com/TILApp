import Routing
import Vapor
import Fluent
import FluentSQL

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {

    let acronymsController = AcronymsController()
    try router.register(collection: acronymsController)

}
