import FluentPostgreSQL
import Vapor
import Leaf
import Authentication

public func configure (_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {

    let serverConfig = NIOServerConfig.default(hostname: "192.168.1.19", port: 8080)
    services.register(serverConfig)

    try services.register(FluentPostgreSQLProvider())
    
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    var commandConfig = CommandConfig.default()
    commandConfig.use(RevertCommand.self, as: "revert")
    services.register(commandConfig)


    var middlewares = MiddlewareConfig()
    middlewares.use(FileMiddleware.self)
    middlewares.use(ErrorMiddleware.self)
    middlewares.use(SessionsMiddleware.self)
    services.register(middlewares)
    
    // Configure a database.
    var databases = DatabasesConfig()

    let databaseName: String
    let databasePort: Int
    // 1
    if (env == .testing) {
        databaseName = "vapor-test"
        if let testPort = Environment.get("DATABASE_PORT") {
            databasePort = Int(testPort) ?? 5433
        } else {
            databasePort = 5433
        }
    } else {
        databaseName = Environment.get("DATABASE_DB") ?? "vapor"
        databasePort = 5432
    }

    let hostname = Environment.get("DATABASE_HOSTNAME") ?? "localhost"
    let username = Environment.get("DATABASE_USER") ?? "vapor"
    let password = Environment.get("DATABASE_PASSWORD") ?? "password"

    let databaseConfig = PostgreSQLDatabaseConfig(
        hostname: hostname,
        // 2
        port : databasePort,
        username: username,
        database: databaseName,
        password: password
    )

    let postgreSQLDatabase = PostgreSQLDatabase(config: databaseConfig)
    databases.add(database: postgreSQLDatabase, as: .psql)
    if (env != .testing) {
        databases.enableLogging(on: .psql)
    }
    services.register(databases)
    
    var migrations = MigrationConfig()
    migrations.add(model: User.self, database: .psql)
    migrations.add(model: Acronym.self, database: .psql)
    migrations.add(model: Category.self, database: .psql)
    migrations.add(model: AcronymCategoryPivot.self, database: .psql)
    migrations.add(model: Token.self, database: .psql)
    migrations.add(migration: AdminUser.self, database: .psql)
    services.register(migrations)

    Account.defaultDatabase = .psql
    
    // Configure Leaf.
    try services.register(LeafProvider())
    config.prefer(LeafRenderer.self, for: ViewRenderer.self)

    try services.register(AuthenticationProvider())

    config.prefer(MemoryKeyedCache.self, for: KeyedCache.self)

    services.register(JJService.self)

}
