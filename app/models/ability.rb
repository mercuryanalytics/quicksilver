# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return if user.blank?

    can :read, :all if user.engineer?
    can :manage, :all if user.admin?
  end
end
