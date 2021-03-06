# frozen_string_literal: true

require 'dotenv/load'
require_relative '../environment.rb'
require 'rom-sql'

require_relative '../lib/persistence/relations/users'
require_relative '../lib/persistence/relations/pokemons'
require_relative '../lib/persistence/relations/spawned_pokemons'
require_relative '../lib/persistence/relations/evolutions'
require_relative '../lib/persistence/relations/fight_types'
require_relative '../lib/persistence/relations/fight_events'
require_relative '../lib/persistence/relations/products'
require_relative '../lib/persistence/relations/trades'
require_relative '../lib/persistence/relations/inventory_items'
require_relative '../lib/persistence/relations/held_items'

# D&D relations
require_relative '../lib/persistence/relations/party_roles'

module Db
  class Connection
    class UnknownEnvironmentError < StandardError; end

    class << self
      def config
        ROM::Configuration.new(:sql, connection_string, options)
      end

      def registered_container
        @_registered_container ||= begin
          configuration = config
          configuration.register_relation(
            Persistence::Relations::Users,
            Persistence::Relations::Pokemons,
            Persistence::Relations::SpawnedPokemons,
            Persistence::Relations::Evolutions,
            Persistence::Relations::FightTypes,
            Persistence::Relations::FightEvents,
            Persistence::Relations::Products,
            Persistence::Relations::Trades,
            Persistence::Relations::InventoryItems,
            Persistence::Relations::HeldItems,
            Persistence::Relations::PartyRoles
          )
          ROM.container(configuration)
        end
      end

      def container
        ROM.container(config)
      end

      private

      def options
        {
          adapter: :postgres,
          encoding: 'UTF8',
        }
      end

      def connection_string
        if Environment.production?
          ENV.fetch('DATABASE_URL')
        elsif Environment.development?
          user = ENV.fetch('DATABASE_USER')
          password = ENV.fetch('DATABASE_PASSWORD')
          host = ENV.fetch('DATABASE_HOST')
          port = ENV.fetch('DATABASE_PORT', 5432)
          db_name = ENV.fetch('DATABASE_NAME')
          "postgres://#{user}:#{password}@#{host}:#{port}/#{db_name}"
        else
          raise UnknownEnvironmentError
        end
      end
    end
  end
end
