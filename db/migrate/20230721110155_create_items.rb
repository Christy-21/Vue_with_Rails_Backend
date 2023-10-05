class CreateItems < ActiveRecord::Migration[5.2]
  def change
    unless table_exists?(:items)
      create_table :items do |t|
        t.string :name
        t.text :description
        t.timestamps
      end
    end
  end
end
