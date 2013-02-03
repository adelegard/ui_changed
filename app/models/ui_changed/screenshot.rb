require 'anemone'
require 'selenium-webdriver'
require 'fileutils'

module UiChanged
  class Screenshot < ActiveRecord::Base
    attr_accessible :is_control,
                    :is_test,
                    :is_compare,
                    :diff_found,
                    :url,
                    :control_id,
                    :test_id,
                    :image_file_name,
                    :image_file_size,
                    :image_content_type,
                    :displayable_image_path_full,
                    :displayable_image_path_small_full

    self.per_page = 15

    class << self

      def start_async_crawl_for_control
        UiChanged::CrawlControl.create
      end

      def start_async_crawl_for_test
        UiChanged::CrawlTest.create
      end
      def start_async_crawl_for_control_and_test
        start_async_crawl_for_control
        start_async_crawl_for_test
      end
      def start_async_crawl_for_control_and_compare
        start_async_crawl_for_control
        start_async_compare
      end
      def start_async_crawl_for_test_and_compare
        start_async_crawl_for_test
        start_async_compare
      end
      def start_async_compare
        UiChanged::Compare.create
      end

      def async_crawl_and_compare
        start_async_crawl_for_control
        start_async_crawl_for_test
        start_async_compare
      end

      def search(search)
        UiChanged::Screenshot.where('ui_changed_screenshots.url LIKE ?', "%#{search}%")
      end
      def set_all_tests_as_controls
        delete_all_controls
        UiChanged::Screenshot.update_all({:is_control => true, :is_test => false}, {:is_test => true})
      end
      def set_tests_as_controls(test_ids)
        test_ids.each do |test_id|
          set_test_as_control(test_id)
        end
      end
      def set_test_as_control(test_id)
        test_ss = UiChanged::Screenshot.find(test_id)
        control_ss = UiChanged::Screenshot.find_by_url_and_is_control(test_ss.url, true)
        compare_ss = UiChanged::Screenshot.find_by_test_id(test_ss.id)

        unless !control_ss
          control_ss.remove_image
          control_ss.destroy
        end
        unless !compare_ss
          compare_ss.remove_image
          compare_ss.destroy
        end

        test_ss.is_control = true
        test_ss.is_test = false
        test_ss.save
        # move test ss's to control dir
        test_ss.move_test_image_to_control
      end

      # delete all entries & images
      def delete_all_controls
        UiChanged::Screenshot.delete_all(:is_control => true)
        UiChanged::Screenshot.delete_all(:is_compare => true)
        FileUtils.rm_rf(Dir.glob(UiChanged::ConfigHelper.control_path + '*'))
        FileUtils.rm_rf(Dir.glob(UiChanged::ConfigHelper.compare_path + '*'))
      end
      def delete_all_tests
        UiChanged::Screenshot.delete_all(:is_test => true)
        UiChanged::Screenshot.delete_all(:is_compare => true)
        FileUtils.rm_rf(Dir.glob(UiChanged::ConfigHelper.test_path + '*'))
        FileUtils.rm_rf(Dir.glob(UiChanged::ConfigHelper.compare_path + '*'))
      end
      def delete_all_compares
        UiChanged::Screenshot.delete_all(:is_compare => true)
        FileUtils.rm_rf(Dir.glob(UiChanged::ConfigHelper.compare_path + '*'))
      end

      def destroy_entries_and_images(ids)
        ids.each do |id|
          destroy_entry_and_image(id)
        end
      end
      def destroy_entry_and_image(id)
        ss = UiChanged::Screenshot.find(id)

        # remove the corresponding compare screenshot
        if ss.is_control
          compare_ss = UiChanged::Screenshot.find_by_control_id(ss.id)
          if compare_ss
            compare_ss.remove_image
            compare_ss.destroy
          end
        elsif ss.is_test
          compare_ss = UiChanged::Screenshot.find_by_test_id(ss.id)
          if compare_ss
            compare_ss.remove_image
            compare_ss.destroy
          end
        end

        ss.remove_image
        ss.destroy
      end

      def remove_all_diffs_and_tests
        delete_all_compares
        delete_all_tests
      end
      def remove_diffs_and_tests(diff_ids)
        diff_ids.split(",").each do |diff_id|
          remove_diff_and_test(diff_id.first.to_i)
        end
      end
      def remove_diff_and_test(diff_id)
        ss_diff = UiChanged::Screenshot.find(diff_id)
        ss_test = UiChanged::Screenshot.find(ss_diff.test_id)
        ss_diff.remove_image
        ss_diff.destroy

        ss_test.remove_image
        ss_test.destroy
      end

      def move_all_test_images_to_control
        # delete all control images
        FileUtils.rm_rf(Dir.glob(UiChanged::ConfigHelper.control_path + '*'))

        # move all test images to control directory
        Dir.foreach(UiChanged::ConfigHelper.test_path) do |img|
          next if img == '.' || img == '..'
          # do work on real items
          UiChanged::Screenshot.move_test_image_to_control(img)
        end
      end

      def move_test_image_to_control(image_file_name_full)
        FileUtils.mv(UiChanged::ConfigHelper.test_path + image_file_name_full,
                     UiChanged::ConfigHelper.control_path + image_file_name_full)
      end

      def not_in_ignored
        UiChanged::Screenshot.joins("LEFT JOIN ui_changed_screenshot_ignore_urls siu ON siu.url = ui_changed_screenshots.url").where('siu.id is null')
      end
    end

    def remove_image
      FileUtils.rm(image_path_full)
      FileUtils.rm(image_path_small_full)
    end

    def move_test_image_to_control
      UiChanged::Screenshot.move_test_image_to_control(image_file_name_full)
      UiChanged::Screenshot.move_test_image_to_control(image_file_name_small_full)
    end

    def image_path_base
      if is_control
        UiChanged::ConfigHelper.control_path
      elsif is_compare
        UiChanged::ConfigHelper.compare_path
      else
        UiChanged::ConfigHelper.test_path
      end
    end

    def displayable_image_path_full
      image_path_full.sub('public','')
    end

    def displayable_image_path_small_full
      image_path_small_full.sub('public','')
    end

    def image_path_full
      image_path_base + image_file_name_full
    end

    def image_path_small_full
      image_path_base + image_file_name_small_full
    end

    def image_file_name_full
      if image_file_name == nil || image_content_type == nil
        return "default.png"
      end
      image_file_name + "." + image_content_type
    end

    def image_file_name_small_full
      if image_file_name == nil || image_content_type == nil
        return "default.png"
      end
      image_file_name + "_small." + image_content_type
    end

    def as_json(*a)
      self.attributes.merge({"displayable_image_path_full" => self.displayable_image_path_full})
    end

  end
end
