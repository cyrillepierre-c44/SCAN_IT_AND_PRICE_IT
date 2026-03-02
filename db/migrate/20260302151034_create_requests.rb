class CreateRequests < ActiveRecord::Migration[8.1]
  def change
    create_table :requests do |t|
      t.string :cleanliness
      t.boolean :fullness
      t.boolean :newness
      t.text :system_prompt

      t.timestamps
    end
  end
end
