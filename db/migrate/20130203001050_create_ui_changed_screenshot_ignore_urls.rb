class CreateUiChangedScreenshotIgnoreUrls < ActiveRecord::Migration
  def change
    create_table :ui_changed_screenshot_ignore_urls do |t|
      t.text :url

      t.timestamps
    end
  end
end
