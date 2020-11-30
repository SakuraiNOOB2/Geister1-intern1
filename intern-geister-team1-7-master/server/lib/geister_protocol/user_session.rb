module GeisterProtocol
  class UserSession < Protocol::Base
    title 'user_session'
    description 'ユーザセッション情報。ユーザの作成とログイン以外の全てのリクエストはログインしている必要がある。ユーザセッションを作成することでログイン、削除することでログアウトの処理を行える。'

    definition(
      :user_session_id,
      description: 'ユーザセッションID',
      example: 1,
      type: Integer
    )

    definition(
      :access_token,
      description: 'アクセストークン。認証が必要なリクエストの際、AUTHORIZATIONヘッダーに `Token token=\"アクセストークン\"` の形式で指定する。',
      example: 'f9425bc7de66d2e78de46a53',
      pattern: /\A[a-zA-Z0-9]{24}\Z/,
      type: String
    )

    definition :user_id, User.ref(:user_id)

    link(
      :create,
      description: 'ユーザセッションの作成（ログイン）',
      path: '/api/user_sessions',
      parameters: {
        name: GeisterProtocol::User.ref(:name),
        password: GeisterProtocol::User.ref(:password)
      },
      target_schema: {
        user_session_id: ref(:user_session_id),
        access_token: ref(:access_token),
        user_id: ref(:user_id)
      }
    )

    link(
      :destroy,
      description: 'ユーザセッションの削除（ログアウト）',
      path: '/api/user_sessions/:user_session_id',
      target_schema: GeisterProtocol::User.ref(:ignore_password_property)
    )
  end
end
