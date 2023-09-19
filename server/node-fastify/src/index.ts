import createConnection from 'knex'

const knex = createConnection({
  client: 'mysql2',
  connection: {
    host: '127.0.0.1',
    port: 3306,
    user: 'root',
    password: '123qweasd',
    database: 'messenger',
  },
})

;(async () => {
  const users = await knex.select('id').from('user')
  console.log(users)
  knex.destroy()
})()
