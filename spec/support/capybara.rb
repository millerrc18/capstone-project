require "capybara/rails"

Capybara.server = :puma, { Silent: true }
Capybara.default_max_wait_time = 5
