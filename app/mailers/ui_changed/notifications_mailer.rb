module UiChanged
  class NotificationsMailer < ActionMailer::Base
    include Resque::Mailer

    default :from => "ui_changed@ui_changed.com"
    default :to => UiChanged::ConfigHelper.email_results_to

    def new_controls_message
      if !UiChanged::ConfigHelper.email_after_control_crawl
        puts '----------- NOT sending email after control crawl -------------'
        return
      end
      count = UiChanged::Screenshot.where(:is_control => true).count

      puts '----------- sending email message after control crawl -------------'
      mail(:subject => "Ui_Changed - saved #{count} control screenshots", :body => "Click here to view them: http://localhost:3000/ui_changed/screenshots/controls")
    end

    def new_tests_message
      if !UiChanged::ConfigHelper.email_after_test_crawl
        puts '----------- NOT sending email after test crawl -------------'
        return
      end
      count = UiChanged::Screenshot.where(:is_test => true).count

      puts '----------- sending email message after test crawl -------------'
      mail(:subject => "Ui_Changed - saved #{count} test screenshots", :body => "Click here to view them: http://localhost:3000/ui_changed/screenshots/tests")
    end

    def new_compares_message
      if !UiChanged::ConfigHelper.email_after_compare
        puts '----------- NOT sending email after compare -------------'
        return
      end
      count = UiChanged::Screenshot.where(:is_compare => true).count

      puts '----------- sending email message after compare -------------'
      mail(:subject => "Ui_Changed - saved #{count} compare screenshots", :body => "Click here to view them: http://localhost:3000/ui_changed/screenshots/compares")
    end

    def new_diffs_message
      if !UiChanged::ConfigHelper.email_after_compare_with_diffs
        puts '----------- NOT sending email after compare with diffs -------------'
        return
      end
      count = UiChanged::Screenshot.where(:diff_found => true).count

      if !UiChanged::ConfigHelper.email_after_compare_with_diffs_on_zero_found && count == 0
        puts '----------- NOT sending email message after compare with diffs b/c zero [diffs] found -------------'
        return
      end

      puts '----------- sending email message after compare with diffs -------------'
      mail(:subject => "Ui_Changed - found #{count} diffs", :body => "Click here to view them: http://localhost:3000/ui_changed/screenshots/diffs")
    end
  end
end