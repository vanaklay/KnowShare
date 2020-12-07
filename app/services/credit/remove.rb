# frozen_string_literal: true

module Credit
  # I called the service 'remove' because the module name is explicit
  class Remove
    def initialize(amount:, user:)
      @amount = amount
      @user = user
    end

    def call
      new_personal_credit = @user.personal_credit - @amount
      @user.update(personal_credit: new_personal_credit)
    end
  end
end
