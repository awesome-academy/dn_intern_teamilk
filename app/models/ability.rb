class Ability
  include CanCan::Ability

  def initialize user
    can :read, Product
    can :read, Review
    can :manage, CartsController
    can :home, PagesController
    can :read, ProductDetail
    return if user.nil?

    can :manage, Review, user_id: user.id
    can :manage, Order, user_id: user.id
    can :manage, Address, user_id: user.id
    return if user.user?

    can :manage, :all
  end
end
