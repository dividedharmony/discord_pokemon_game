# frozen_string_literal: true

TestingFactory.define(:user) do |factory|
  factory.discord_id { '123456789' }
  factory.created_at { Time.now }
  factory.exp_per_step 50
end
