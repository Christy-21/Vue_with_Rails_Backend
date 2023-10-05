# db/migrate/[TIMESTAMP]_create_templates.rb

class CreateTemplates < ActiveRecord::Migration[5.2]
  def change
    create_table :templates do |t|
      t.string :templateName
      t.text :templateDescription
      t.string   :filename,   null: false
      t.timestamps
    
    end
  end
end
