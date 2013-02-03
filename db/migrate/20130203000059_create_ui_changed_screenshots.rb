class CreateUiChangedScreenshots < ActiveRecord::Migration
  def change
    create_table :ui_changed_screenshots do |t|
      t.text :url
      t.boolean :is_control
      t.boolean :is_test
      t.boolean :is_compare
      t.boolean :diff_found
      t.integer :control_id
      t.integer :test_id
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size

      t.timestamps
    end
  end
end
