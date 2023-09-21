import createConnection from 'knex'
import path from 'path'

import protobuf from 'protobufjs'
import { ProtobufTypesMap } from './utils'
import { ProtobufEnums, ProtobufTypes } from './types/protobuf'

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

const pathToProto = path.join(__dirname, '../../../protobuf/messenger.proto')

;(async () => {
  const users = await knex.select('id').from('user')
  console.log(users)
  knex.destroy()

  const root = await protobuf.load(pathToProto)

  const typesMap = new ProtobufTypesMap<ProtobufTypes, ProtobufEnums>(root)

  typesMap.typegen(path.join(__dirname, 'types'))
})()
