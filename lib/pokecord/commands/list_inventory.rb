# frozen_string_literal: true

require 'dry/monads/do'

require_relative './base_user_command'
require_relative '../../repositories/inventory_item_repo'

module Pokecord
  module Commands
    class ListInventory < BaseUserCommand
      InventoryPayload = Struct.new(:user, :inventory_items)

      include Dry::Monads::Do.for(:call)

      def initialize(discord_id)
        @inventory_repo = Repositories::InventoryItemRepo.new(
          Db::Connection.registered_container
        )
        super(discord_id)
      end

      def call
        user = yield get_user

        inventory_items = visible_inventory.where(user_id: user.id).to_a
        if inventory_items.none?
          Failure(I18n.t('inventory.no_items'))
        else
          Success(inventory_items)
        end
      end

      private

      attr_reader :inventory_repo

      def visible_inventory
        inventory_repo.
          inventory_items.
          combine(:product).
          where { amount > 0 }
      end
    end
  end
end
