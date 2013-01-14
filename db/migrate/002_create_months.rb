class CreateMonths < ActiveRecord::Migration
  def self.up
    create_table :months do |t|
      t.integer :year
      t.integer :month
      t.string :accounts_json
      t.timestamps
    end
  end

  def self.down
    drop_table :months
  end
end
