module UiChanged
  class NotificationsMailer < ActionMailer::Base
    include Resque::Mailer

    default :from => "contact@cocktailrecipes.com"
    default :to => "emailtester147@gmail.com"

    def new_message(params)
      num_diffs = UiChanged::Screenshot.where(:diff_found => true).count
      mail(:subject => "Ui_Changed - found #{num_diffs} diffs", :body => "Click here to view them: http://localhost:3000/ui_changed/screenshots/diffs")
    end
  end
end