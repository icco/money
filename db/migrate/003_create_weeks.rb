class CreateWeeks < ActiveRecord::Migration
  def self.up
    create_table :weeks do |t|
      t.integer :year
      t.integer :week
      t.string :accounts_json
      t.timestamps
    end
  end

  def self.down
    drop_table :weeks
  end
end
