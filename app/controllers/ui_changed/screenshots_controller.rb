require_dependency "ui_changed/application_controller"
require 'anemone'
require 'fileutils'

module UiChanged
  class ScreenshotsController < ScreenshotsControllerBase

    # GET /screenshots
    def index
      @crawl_working = is_any_job_running_or_queued ? "true" : "false"
    end

    # GET /screenshots/crawl_status.json
    def crawl_status
      first_status = crawl_statuses.first
      screenshots = []
      if first_status
        screenshots = UiChanged::Screenshot.where("created_at > ?", first_status.time).order("id desc").limit(50).reverse
      end

      job = job_running
      if job != nil
        job_running_status = job.status
        if job.name && job.name.include?("Control")
          job_running_type = "control"
        elsif job.name &&job.name.include?("Test")
          job_running_type = "test"
        elsif job.name
          job_running_type = "compare"
        end
      end

      diff_count = UiChanged::Screenshot.not_in_ignored.where(:diff_found => true).count
      control_count = UiChanged::Screenshot.not_in_ignored.where(:is_control => true).count
      test_count = UiChanged::Screenshot.not_in_ignored.where(:is_test => true).count
      compare_count = UiChanged::Screenshot.not_in_ignored.where(:is_compare => true).count

      render :json => [{
        :screenshots => screenshots,
        :counts => {
          :diff => diff_count,
          :control => control_count,
          :test => test_count,
          :compare => compare_count,
        },
        :worker => {
          :running_status => job_running_status,
          :running_type => job_running_type,
          :first_status => first_status ? first_status.status : ""
        }
      }]
    end

    # POST /screenshots/ignored
    def cancel
      # there has got to be a sexy ruby way of doing this
      crawl_statuses.each do |job|
        next unless is_job_running(job.status)
        job_id = job.uuid
        puts 'cancelling job_id: ' + job_id.to_s
        Resque::Plugins::Status::Hash.kill(job_id)
      end

      # and for good measure
      `redis-cli FLUSHALL`

      head :ok
    end

    # GET /screenshots/diffs
    def diffs
      params[:sort] ||= "image_file_size desc"
      @diffs = UiChanged::Screenshot.search(params[:search]).not_in_ignored.where(:diff_found => true).paginate(:page => params[:page],
                                                                                  :per_page => params[:per_page],
                                                                                  :order => params[:sort])
      @all_screenshots = []
      @diffs.each do |diff|
        control = UiChanged::Screenshot.find(diff.control_id)
        test = UiChanged::Screenshot.find(diff.test_id)
        @all_screenshots << UiChanged::AllScreenshot.new(control, test, diff)
      end
    end

    # GET /screenshots/compares
    def compares
      params[:sort] ||= "ui_changed_screenshots.url asc"
      @screenshots = UiChanged::Screenshot.search(params[:search]).not_in_ignored.where(:is_compare => true)
                                                                  .paginate(:page => params[:page],
                                                                            :per_page => params[:per_page],
                                                                            :order => params[:sort])
      @type = "Compare"
      render "ui_changed/screenshots/screenshots"
    end

    # GET /screenshots/controls
    def controls
      params[:sort] ||= "ui_changed_screenshots.url asc"
      @screenshots = UiChanged::Screenshot.search(params[:search]).not_in_ignored.where(:is_control => true)
                                                                  .paginate(:page => params[:page],
                                                                            :per_page => params[:per_page],
                                                                            :order => params[:sort])
      @type = "Control"
      render "ui_changed/screenshots/screenshots"
    end

    # GET /screenshots/tests
    def tests
      params[:sort] ||= "ui_changed_screenshots.url asc"
      @screenshots = UiChanged::Screenshot.search(params[:search]).not_in_ignored.where(:is_test => true)
                                                                  .paginate(:page => params[:page],
                                                                            :per_page => params[:per_page],
                                                                            :order => params[:sort])
      @type = "Test"
      render "ui_changed/screenshots/screenshots"
    end

    # GET /screenshots/diff
    def diff
      @diff = UiChanged::Screenshot.find(params[:diff_id])
      @control = UiChanged::Screenshot.find(@diff.control_id)
      @test = UiChanged::Screenshot.find(@diff.test_id)
    end

    # DELETE /screenshots/destroy
    def destroy
      UiChanged::Screenshot.destroy_entries_and_images(params[:id].split(","))
      head :ok
    end

    # DELETE /screenshots/destroy_all_controls
    def destroy_all_controls
      UiChanged::Screenshot.delete_all_controls
      head :ok
    end

    # DELETE /screenshots/destroy_all_tests
    def destroy_all_tests
      UiChanged::Screenshot.delete_all_tests
      head :ok
    end

    # DELETE /screenshots/destroy_all_compares
    def destroy_all_compares
      UiChanged::Screenshot.delete_all_compares
      head :ok
    end

    # remove all diffs & tests
    # DELETE /screenshots/remove_all_diffs_and_tests
    def remove_all_diffs_and_tests
      UiChanged::Screenshot.remove_all_diffs_and_tests
      head :ok
    end

    # DELETE /screenshots/remove_diff_and_test
    def remove_diff_and_test
      UiChanged::Screenshot.remove_diffs_and_tests(params[:id].split(","))
      head :ok
    end

    # set tests as controls and DELETE controls and DELETE diffs
    # POST /screenshots/set_all_tests_as_control
    def set_all_tests_as_control
      UiChanged::Screenshot.set_all_tests_as_controls
      head :ok
    end

    # POST /screenshots/set_test_as_control
    def set_test_as_control
      UiChanged::Screenshot.set_tests_as_controls(params[:id].split(","))
      head :ok
    end

    # crawling & comparing

    # POST /screenshots/start_all
    def start_all
      UiChanged::Screenshot.async_crawl_and_compare
      head :ok
    end

    # POST /screenshots/start_control
    def start_control
      UiChanged::Screenshot.start_async_crawl_for_control
      head :ok
    end

    # POST /screenshots/start_test
    def start_test
      UiChanged::Screenshot.start_async_crawl_for_test
      head :ok
    end

    # POST /screenshots/start_control_test
    def start_control_test
      UiChanged::Screenshot.start_async_crawl_for_control_and_test
      head :ok
    end

    # POST /screenshots/start_control_compare
    def start_control_compare
      UiChanged::Screenshot.start_async_crawl_for_control_and_compare
      head :ok
    end

    # POST /screenshots/start_test_compare
    def start_test_compare
      UiChanged::Screenshot.start_async_crawl_for_test_and_compare
      head :ok
    end

    # POST /screenshots/start_compare
    def start_compare
      UiChanged::Screenshot.start_async_compare
      head :ok
    end

    private

    def crawl_statuses
      Resque::Plugins::Status::Hash.statuses
    end

    def job_running
      currently_running = nil
      crawl_statuses.each do |job|
        if is_job_running(job.status)
          currently_running = job
          break
        end
      end
      currently_running
    end

    def all_running
      all = []
      crawl_statuses.each do |job|
        if is_job_running(job.status)
          all << job
        end
      end
      all
    end

    def job_running_status
      job = job_running
      return unless job != nil
      job.status
    end

    def is_any_job_running_or_queued
      crawl_statuses.each do |job|
        return true unless !is_job_running_or_queued(job.status)
      end
      return false
    end

    def is_job_running_or_queued(status)
      return status == "working" || status == "queued"
    end

    def is_job_running(status)
      return status == "working"
    end
  end
end
