# db/migrate/20230721104908_add_scanned_copy_to_items.rb

class AddScannedCopyToItems < ActiveRecord::Migration[5.2]
  def up
    # Create the "items" table first if it doesn't exist
    create_table :items unless table_exists?(:items)

    # Add the "scanned_copy" column to the "items" table
    add_column :items, :scanned_copy, :string
  end

  def down
    # Remove the "scanned_copy" column from the "items" table
    remove_column :items, :scanned_copy

    # You may also need to drop the "items" table if you want to rollback this migration completely
    drop_table :items
  end
end
