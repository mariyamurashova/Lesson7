module Validation
  
def valid?
    validation!
    true
  rescue StandardError
    false
end
end

