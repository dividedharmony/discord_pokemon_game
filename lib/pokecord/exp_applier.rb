# frozen_string_literal: true

require_relative '../../db/connection'
require_relative '../repositories/spawned_pokemon_repo'

require_relative './exp_curve'

module Pokecord
  class ExpApplier
    LevelUpPayload = Struct.new(:spawned_pokemon, :level)

    def initialize(spawned_pokemon, incoming_exp)
      @spawned_pokemon = spawned_pokemon
      @incoming_exp = incoming_exp
      @current_level = spawned_pokemon.level
      @spawn_repo = Repositories::SpawnedPokemonRepo.new(
        Db::Connection.registered_container
      )
      @leveled_up = false
    end

    def apply!
      return if current_level < 1 || current_level >= 100
      total_exp = spawned_pokemon.current_exp + incoming_exp
      if total_exp >= spawned_pokemon.required_exp
        @leveled_up = true
        @current_level += 1
        new_total_exp = total_exp - spawned_pokemon.required_exp
        new_required_exp = Pokecord::ExpCurve.new(@current_level).required_exp_for_next_level
        update_command.call(
          level: current_level,
          current_exp: new_total_exp,
          required_exp: new_required_exp
        )
      else
        update_command.call(current_exp: total_exp)
      end
    end

    def payload
      return nil unless leveled_up
      LevelUpPayload.new(spawned_pokemon, current_level)
    end

    private

    attr_reader :spawned_pokemon, :incoming_exp, :spawn_repo, :current_level, :leveled_up

    def update_command
      spawn_repo.
        spawned_pokemons.
        by_pk(spawned_pokemon.id).
        command(:update)
    end

    def reload!
      @spawned_pokemon = spawn_repo.
        spawned_pokemons.
        combine(:pokemon).
        where(id: spawned_pokemon.id).
        one!
    end
  end
end