module GeneralMethods
  def valid?
    validate!
    true
  rescue
    false
  end
end
