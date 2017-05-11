class Restart < ActiveRecord::Migration[5.0]
  def change
    drop_table :weeks {|t| }
    drop_table :months {|t| }
    drop_table :accounts {|t| }

    create_table :records do |t|
      t.timestamps
      t.string :name
      t.string :native_id
      t.money :usd
    end
  end
end
