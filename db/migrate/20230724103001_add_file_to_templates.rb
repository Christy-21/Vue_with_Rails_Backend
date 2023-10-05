class AddFileToTemplates < ActiveRecord::Migration[5.2]
  def change
    add_column :templates, :file, :string
  end
end
