# frozen_string_literal: true

require 'dry/monads/do'

require_relative './base_user_command'

module Pokecord
  module Commands
    class BaseInventoryCommand < BaseUserCommand
      def initialize(discord_id, product_name)
        @product_name = product_name
        super(discord_id)
      end

      def call
        raise NotImplementedError, "#{self.class.name} needs to implment the #call method"
      end

      def get_product
        local_name_var = product_name
        products = repos.products.where { name.ilike(local_name_var) }
        if only_visible_products
          products = products.where(visible: true)
        end
        if products.to_a.none?
          Failure(I18n.t('inventory.no_such_product', product_name: product_name))
        else
          Success(products.first)
        end
      end

      def find_or_create_inventory_item(user, product)
        item = repos.inventory_items.where(user_id: user.id, product_id: product.id).first
        item || repos.inventory_repo.create(
          user_id: user.id,
          product_id: product.id,
          created_at: Time.now,
          updated_at: Time.now
        )
      end

      private

      attr_reader :product_name

      def only_visible_products
        raise NotImplementedError, "#{self.class.name} needs to implment the #only_visible_products method"
      end
    end
  end
end
