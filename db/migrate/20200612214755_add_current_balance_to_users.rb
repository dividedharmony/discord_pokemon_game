# frozen_string_literal: true

ROM::SQL.migration do
  change do
    alter_table(:users) do
      add_column :current_balance, Integer, null: false, default: 0
    end
  end
end
