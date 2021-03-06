# frozen_string_literal: true

require 'rom/sql/rake_task'

namespace :db do
  task :setup do
    require_relative './db/connection'
    ROM::SQL::RakeSupport.env = Db::Connection.container
  end

  task :seed do
    Rake::Task['pokecord:populate_pokemon'].execute
    Rake::Task['pokecord:populate_starters'].execute
    Rake::Task['pokecord:populate_galar_pokemon'].execute
    Rake::Task['pokecord:populate_rarity'].execute
    Rake::Task['pokecord:populate_fight_types'].execute
    Rake::Task['pokecord:populate_products'].execute
    Rake::Task['pokecord:populate_evolutions'].execute
  end

  namespace :test do
    task :clean do
      require 'dotenv'
      Dotenv.load('.env.test')
      require_relative './db/connection'
      ROM::SQL::RakeSupport.env = Db::Connection.container
      Rake::Task['db:clean'].execute
    end

    task :setup do
      require 'dotenv'
      Dotenv.load('.env.test')
      require_relative './db/connection'
      ROM::SQL::RakeSupport.env = Db::Connection.container
      Rake::Task['db:clean'].execute
      Rake::Task['db:migrate'].execute
    end
  end
end

namespace :dnd do
  task :populate_party_roles do
    require_relative './lib/taskers/dnd/populate_party_roles'
    Taskers::Dnd::PopulatePartyRoles.new.call
  end
end

namespace :pokecord do
  task :populate_pokemon do
    require_relative './lib/taskers/populate_pokemons'
    Taskers::PopulatePokemons.new.call
  end

  task :populate_galar_pokemon do
    require_relative './lib/taskers/populate_pokemon_from_csv'
    galar_file = File.expand_path('pokemon_info/galar_pokedex.csv', File.dirname(__FILE__))
    Taskers::PopulatePokemonFromCsv.new(galar_file).call
  end

  task :populate_rarity do
    require_relative './lib/taskers/populate_rarity'
    rarity_file = File.expand_path('pokemon_info/rarity.csv', File.dirname(__FILE__))
    Taskers::PopulateRarity.new(rarity_file).call
  end

  task :populate_catch_numbers do
    require_relative './lib/taskers/populate_catch_numbers'
    Taskers::PopulateCatchNumbers.new.call
  end

  task :populate_starters do
    require_relative './lib/taskers/populate_starters'
    Taskers::PopulateStarters.new.call
  end

  task :populate_levels do
    require_relative './lib/taskers/populate_levels'
    Taskers::PopulateLevels.new.call
  end

  task :populate_required_exp do
    require_relative './lib/taskers/populate_required_exp'
    Taskers::PopulateRequiredExp.new.call
  end

  task :populate_fight_types do
    require_relative './lib/taskers/populate_fight_types'
    Taskers::PopulateFightTypes.new.call
  end

  task :reset_users_exp_per_step do
    require_relative './lib/taskers/reset_users_exp_per_step'
    Taskers::ResetUsersExpPerStep.new.call
  end

  task :populate_products do
    require_relative './lib/taskers/populate_products'
    Taskers::PopulateProducts.new.call
  end

  task :populate_evolutions do
    require_relative './lib/taskers/populate_evolutions'
    evolutions_file = File.expand_path('pokemon_info/evolutions.csv', File.dirname(__FILE__))
    Taskers::PopulateEvolutions.new(evolutions_file).call
  end
end
