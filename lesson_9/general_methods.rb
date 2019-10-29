# frozen_string_literal: true

module GeneralMethods
  def valid?
    validate!
    true
  rescue StandardError
    false
  end
end
