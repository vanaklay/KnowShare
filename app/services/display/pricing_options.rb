# frozen_string_literal: true

module Display
  class PricingOptions
    def initialize(credit_order:)
      @credits = credit_order.number_of_credit
    end

    def call
      option_to_display
    end

    def option_to_display
      case @credits
      when 1
        'Découverte'
      when 10
        'Pro'
      when 20
        'Master'
      else
        'Aucune !'
      end
    end
  end
end
