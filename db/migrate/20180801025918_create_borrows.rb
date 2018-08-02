class CreateBorrows < ActiveRecord::Migration[5.2]
  def change
    create_table :borrows do |t|
      t.date :borrowed_date
      t.date :returned_date
      t.datetime :real_borrowed_date
      t.integer :status, null: false, default: 0
      t.references :user, foreign_key: true
      t.references :book, foreign_key: true

      t.timestamps
    end
  end
end
