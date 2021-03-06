# frozen_string_literal: true

require 'rom-sql'

module Persistence
  module Relations
    class FightTypes < ROM::Relation[:sql]
      schema(:fight_types, infer: true) do
        associations do
          has_many :fight_events
        end
      end

      auto_struct(:true)
    end
  end
end
