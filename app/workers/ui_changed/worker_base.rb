module UiChanged
  class WorkerBase

    protected

    def crawl_by_is_control(is_control)
      if is_control
        image_dir = UiChanged::ConfigHelper.control_path
        crawl_url = UiChanged::ConfigHelper.control_url
      else
        image_dir = UiChanged::ConfigHelper.test_path
        crawl_url = UiChanged::ConfigHelper.test_url
      end
      crawl_by_image_dir_and_is_control_and_url(image_dir, is_control, crawl_url)
    end

    def crawl_by_is_control_and_url(is_control, crawl_url)
      if is_control
        image_dir = UiChanged::ConfigHelper.control_path
      else
        image_dir = UiChanged::ConfigHelper.test_path
      end
      crawl_by_image_dir_and_is_control_and_url(image_dir, is_control, crawl_url)
    end

    def crawl_by_image_dir_and_is_control_and_url(image_dir, is_control, crawl_url)
      status_msg = "removing all matching db entries & images: (is_control: " + is_control.to_s + ")"
      tick(status_msg)
      puts status_msg
      is_control ? UiChanged::Screenshot.delete_all_controls : UiChanged::Screenshot.delete_all_tests

      # not super ideal
      # ideally we do this after crawling and deleting
      # only screenshot rows where is_compare => true
      # and where control_id or test_id is dangling (no longer exists)
      UiChanged::Screenshot.delete_all_compares

      puts "is_control: " + is_control.to_s

      # does control/test directory exist?
      # if so remove everything in it
      # if not, create it
      remove_folder_contents_or_create(image_dir)

      driver = Selenium::WebDriver.for :chrome
      driver.manage.window.resize_to(1024, 768) # this doesn't work (i dont think)
      driver.manage.timeouts.implicit_wait = 60 # seconds

      urls_to_skip = UiChanged::ScreenshotIgnoreUrl.all_ignores_urls_as_reg_exp
      puts urls_to_skip.to_s

      skip_query_strings = UiChanged::ConfigHelper.skip_query_strings ||= false
      puts 'skip query strings: ' + skip_query_strings.to_s

      STDOUT.flush
      count = 0
      Anemone.crawl(crawl_url, :skip_query_strings => skip_query_strings) do |anemone|
        anemone.skip_links_like urls_to_skip
        anemone.on_every_page do |page|

          status_msg = "browsing to " + page.url.to_s + "  --- " + count.to_s
          tick(status_msg)
          puts status_msg

          crawl_and_save_single_url(image_dir, is_control, page.url, driver)

          count += 1
        end
      end

      # here you need to
      # delete all screenshots 
      # where is_compare = true AND control_id

      if is_control
        UiChanged::NotificationsMailer.new_controls_message.deliver
      else
        UiChanged::NotificationsMailer.new_tests_message.deliver
      end

      driver.quit
    end

    def crawl_and_save_single_url(image_dir, is_control, page_url, driver)
  #    ss_ignore = ScreenshotIgnoreUrl.where(:url => page_url)
  #    if ss_ignore.size == 0
  #      return
  #    end

      if is_control
        ss = UiChanged::Screenshot.find_or_create_by_url_and_is_control(page_url.to_s, true)
      else
        ss = UiChanged::Screenshot.find_or_create_by_url_and_is_test(page_url.to_s, true)
      end
      puts 'found or created ss id: ' + ss.id.to_s
      image_file_name = "image_" + ss.id.to_s
      image_file_name_small = image_file_name + "_small"
      image_path = image_dir + image_file_name + ".png"
      image_path_small = image_dir + image_file_name_small + ".png"

      driver.get page_url.to_s
      begin
        puts "generating ss: " + image_file_name
        driver.save_screenshot image_path
      rescue Selenium::WebDriver::Error::UnknownError
        #sometimes the page body is null???
      end

      # create the icon version of the image
      puts "generating small ss: " + image_file_name_small
      `convert #{image_path} -resize 30x30 #{image_path_small}`

      ss.update_attributes(:image_file_name => image_file_name,
                           :image_content_type => "png",
                           :image_file_size => File.size(image_path))
      ss.save

      STDOUT.flush
    end

    def start_comparing
      tick("starting compare")
      compare_image_dir = UiChanged::ConfigHelper.compare_path

      if !Dir.exists?(UiChanged::ConfigHelper.control_path) || !Dir.exists?(UiChanged::ConfigHelper.test_path)
        # can't do any comparison! later.
        return
      end

      puts 'removing all diff database entries...'
      UiChanged::Screenshot.delete_all(["is_compare = ?", true])

      # does compare directory exist?
      # if so remove everything in it
      # if not, create it
      remove_folder_contents_or_create(compare_image_dir)

      control_images = UiChanged::Screenshot.where(:is_control => true)
      control_images.each do |control_image|
        puts "comparing screenshots of url: " + control_image.url.to_s
        test_image = UiChanged::Screenshot.where(:url => control_image.url, :is_test => true).first
        control_image_path = control_image.image_path_full
        test_image_path = test_image.image_path_full

        diff_image_file_name = "image_" + control_image.id.to_s + "_" + test_image.id.to_s
        diff_image_path = compare_image_dir + diff_image_file_name + ".png"
        diff_image_path_small = compare_image_dir + diff_image_file_name + "_small.png"
        diff_found = compare(control_image_path, test_image_path, diff_image_path, diff_image_path_small)

        ss = UiChanged::Screenshot.find_or_create_by_control_id_and_test_id(control_image.id, test_image.id)
        ss.update_attributes(:image_file_name => diff_image_file_name,
                             :image_content_type => "png",
                             :url => control_image.url,
                             :is_control => false,
                             :is_test => false,
                             :is_compare => true,
                             :diff_found => diff_found,
                             :image_file_size => File.size(diff_image_path))
        ss.save
        status_msg = "generating compare ss: " + diff_image_file_name
        tick(status_msg)
        puts status_msg
      end

      UiChanged::NotificationsMailer.new_compares_message.deliver
      UiChanged::NotificationsMailer.new_diffs_message.deliver

    end

    private

    def remove_folder_contents_or_create(path)
      # does control/test directory exist?
      puts 'checking if dir exists: ' + path
      if Dir.exists?(path)
        path_contents = path + '*'
        puts 'removing directory contents of :' + path_contents
        FileUtils.rm_rf(Dir.glob(path_contents))
      else
        # create control/test folder
        create_folders(path)
      end
    end

    def create_folders(path)
      unless Dir.exists?(path)
        puts 'creating dir path: ' + path.to_s
        FileUtils.mkdir_p path
      end
    end

    def compare(control_img, test_img, diff_img, diff_img_small)
      args = "-compose Src -highlight-color #FF0000 #{control_img} #{test_img} #{diff_img}"
      puts args
      `compare #{args}`

      # create the icon version of the diff image
      puts "generating small ss: " + diff_img_small
      `convert #{diff_img} -resize 30x30 #{diff_img_small}`

      diff_found = `convert #{diff_img} -format %c -depth 8 histogram:info:-`
      return diff_found.include? "#FF0000"
    end
  end
end