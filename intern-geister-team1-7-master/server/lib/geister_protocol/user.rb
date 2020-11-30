module GeisterProtocol
  class User < Protocol::Base
    title 'user'
    description 'ユーザ情報'

    definition(
      :user_id,
      description: 'ユーザID',
      example: 1,
      type: Integer
    )

    definition(
      :name,
      description: 'ユーザ名(英数字4文字以上16文字以下)',
      example: 'alice',
      pattern: /\A[a-zA-Z0-9]{4,16}\Z/,
      type: String
    )

    definition(
      :created_at,
      description: 'ユーザの作成日時',
      format: 'date-time',
      example: '2016-01-01T00:00:00Z',
      type: Time
    )

    definition(
      :updated_at,
      description: 'ユーザの更新日時',
      format: 'date-time',
      example: '2016-01-01T00:00:00Z',
      type: Time
    )

    definition(
      :password,
      description: 'パスワード（英数字8文字以上16文字以下）',
      example: 'password1234',
      pattern: /\A[a-zA-Z0-9]{8,16}\Z/,
      type: String
    )

    definition(
      :ignore_password_property,
      user_id: ref(:user_id),
      name: ref(:name),
      created_at: ref(:created_at),
      updated_at: ref(:updated_at)
    )

    property :user_id,    ref(:user_id)
    property :name,       ref(:name)
    property :password,   ref(:password)
    property :created_at, ref(:created_at)
    property :updated_at, ref(:updated_at)

    link(
      :show,
      description: 'ユーザ情報の取得',
      path: '/api/users/:user_id',
      target_schema: ref(:ignore_password_property)
    )

    link(
      :create,
      description: 'ユーザの作成',
      path: '/api/users',
      parameters: {
        name: ref(:name),
        password: ref(:password)
      },
      target_schema: ref(:ignore_password_property)
    )
  end
end
