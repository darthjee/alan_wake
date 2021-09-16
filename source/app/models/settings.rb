# frozen_string_literal: true

class Settings
  extend Sinclair::EnvSettable

  settings_prefix 'ALAN_WAKE'

  with_settings(
    cache_age: 10.seconds
  )
end
