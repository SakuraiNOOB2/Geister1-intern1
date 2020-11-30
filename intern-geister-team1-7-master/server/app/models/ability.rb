class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    unless user.entered?
      can :create, Room
      can :create, PlayerEntry
      can :create, SpectatorEntry
    end

    can :show, Game, user: user
    can :destroy, UserSession, user: user
    can :destroy, PlayerEntry, user: user
    can :destroy, SpectatorEntry, user: user
  end
end
