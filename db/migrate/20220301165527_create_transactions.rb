class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.string :payer
      t.integer :points
      t.datetime :timestamp

      t.timestamps
    end
  end
end
