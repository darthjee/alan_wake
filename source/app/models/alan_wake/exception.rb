# frozen_string_literal: true

module AlanWake
  class Exception < StandardError
    class LoginFailed  < AlanWake::Exception; end
    class Unauthorized < AlanWake::Exception; end
    class NotLogged    < AlanWake::Exception; end
  end
end
