# frozen_string_literal: true

module Credit
  # I called the service 'add' because the module name is explicit
  class Add
    def initialize(amount:, user:)
      @amount = amount
      @user = user
    end

    def call
      new_personal_credit = @user.personal_credit + @amount
      user.update(personal_credit: new_personal_credit)
    end
  end
end
