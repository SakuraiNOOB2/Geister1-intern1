module GeisterProtocol
  include ::JsonWorld::DSL

  title 'API for Geister'
  description 'API for Geister in DOKIDOKI GROOVEWORKS'

  property(:user, links: true, type: User)
  property(:user_session, links: true, type: UserSession)
  property(:room, links: true, type: Room)
  property(:player_entry, links: true, type: PlayerEntry)
  property(:spectator_entry, links: true, type: SpectatorEntry)
  property(:game, links: true, type: Game)
  property(:piece, links: true, type: Piece)
end
