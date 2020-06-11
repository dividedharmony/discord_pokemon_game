# frozen_string_literal: true

require 'rom/sql/rake_task'

namespace :db do
  task :setup do
    require_relative './db/connection'
    ROM::SQL::RakeSupport.env = Db::Connection.container
  end

  namespace :test do
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

namespace :pokecord do
  task :populate_pokemon do
    require_relative './lib/taskers/populate_pokemons'
    Taskers::PopulatePokemons.new.call
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
end
