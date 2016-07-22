class Ability
  include CanCan::Ability

  def initialize user, id = nil
    user ||= User.new

    if user.hr?
      can :read, :all
    elsif user.admin?
      can :manage, :all
    else
      cannot :manage, :all
    end
  end
end
