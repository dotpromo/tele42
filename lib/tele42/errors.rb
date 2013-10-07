module Tele42
  class InvalidUserName < StandardError; end
  class InvalidPassword < StandardError; end
  class InvalidServer < StandardError; end
  class InvalidFrom < StandardError; end
  class InvalidRoute < StandardError; end
  class BadLoginDetails < StandardError; end
  class BadMessage < StandardError; end
  class BadNumber < StandardError; end
  class NotEnoughCredits < StandardError; end
end