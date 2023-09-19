// common abstract interfaces

export interface PrimaryKey {
  id: number
}

export interface TimeCreated {
  created_at: Date
}

export interface TimeUpdated {
  created_at: Date
}

export interface TimeCreatedUpdated extends TimeCreated, TimeUpdated {}

export interface Profile {
  token: string
  img: string | null
  desc: string | null
}

export interface ChatUser {
  chat_id: number
  user_id: number

  User?: User
  Chat?: Chat
}

// actual models

export interface User extends PrimaryKey, TimeCreated, Profile {
  password: string
}

export interface Chat extends PrimaryKey, TimeCreated {
  public: boolean

  PublicChat?: PublicChat
  Subscribers?: Subscriber[]
}

export interface PublicChat extends Profile {
  chat_id: number
  owner_id: number

  Chat?: Chat
  Owner?: User
}

export interface Subscriber extends TimeCreated, ChatUser {}

export interface Message extends TimeCreatedUpdated, ChatUser {
  delivered: boolean
  value: string | null
}

export interface Read extends TimeCreated, ChatUser {
  read_by_id: number

  ReadBy?: User
}
