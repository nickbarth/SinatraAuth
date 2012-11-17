ActiveRecord::Base.
  establish_connection(
  {
    adapter:     'sqlite3',
    database:    './db/database.sqlite',
    pool:         4,
    timeout:      240,
    wait_timeout: 0.24
  }
)
