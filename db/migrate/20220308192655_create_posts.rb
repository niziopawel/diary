# frozen_string_literal: true

class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.text :notice
      t.integer :temperature
      t.references :user, null: false, foreign_key: true
      t.string :city

      t.timestamps
    end
  end
end
