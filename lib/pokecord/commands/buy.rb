# frozen_string_literal: true

require 'dry/monads/do'

require_relative './base_inventory_command'

module Pokecord
  module Commands
    class Buy < BaseInventoryCommand
      include Dry::Monads::Do.for(:call)

      def initialize(discord_id, product_name, purchase_amount)
        @purchase_amount = purchase_amount
        super(discord_id, product_name)
      end

      def call
        user = yield get_user
        product = yield get_product
        yield validate_can_purchase(user, product)

        inventory_item = find_or_create_inventory_item(user, product)
        new_item_total = inventory_item.amount + purchase_amount
        new_balance = user.current_balance - product.price
        update_user_cmd = repos.users.by_pk(user.id).command(:update)
        update_user_cmd.call(current_balance: new_balance)
        update_item_cmd = repos.inventory_items.by_pk(inventory_item.id).command(:update)
        update_item_cmd.call(amount: new_item_total, updated_at: Time.now)
        Success(I18n.t('buy.success', amount: purchase_amount, product_name: product.name))
      end

      private

      attr_reader :purchase_amount

      def validate_can_purchase(user, product)
        if purchase_amount < 1
          Failure(I18n.t('buy.amount_must_be_greater_than_zero', amount: purchase_amount))
        elsif user.current_balance < (purchase_amount * product.price)
          Failure(I18n.t('buy.insufficient_funds', amount: purchase_amount, product_name: product.name))
        else
          Success(product)
        end
      end

      def only_visible_products
        true
      end
    end
  end
end
