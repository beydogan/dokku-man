Plugin.create(
  name: "Redis",
  slug: "redis",
  url: "https://github.com/dokku/dokku-redis.git",
  version: "3.0.7",
  class_name: "RedisInstance"

)

Plugin.create(
  name: "PostgreSQL",
  slug: "postgres",
  url: "https://github.com/dokku/dokku-postgres.git",
  version: "9.5.2",
  class_name: "PostgresInstance"
)