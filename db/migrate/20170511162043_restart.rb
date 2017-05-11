class Restart < ActiveRecord::Migration[5.0]
  def change
    drop_table :weeks
    drop_table :months
    drop_table :accounts

    create_table :records do |t|
      t.timestamps
      t.string :name
      t.money :amount
    end
  end
end
