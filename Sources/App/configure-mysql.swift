import FluentMySQL
import Vapor

public func configure (_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    
    try services.register(FluentMySQLProvider())
    
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)
    
    var middlewares = MiddlewareConfig()
    middlewares.use(DateMiddleware.self)
    middlewares.use(ErrorMiddleware.self)
    services.register(middlewares)
    
    // Configure a database.
    var databases = DatabaseConfig()
    
    let databaseConfig = MySQLDatabaseConfig(
        hostname: "127.0.0.1",
        port: 3306,
        username: "vapor",
        password: "password",
        database: "vapor"
    )
    let database = MySQLDatabase(config: databaseConfig)
    databases.add(database: database, as: .mysql)
    services.register(databases)
    
    var migrations = MigrationConfig()
    migrations.add(model: Acronym.self, database: .mysql)
    services.register(migrations)
    
}
