module UiChanged
  class CrawlTest < WorkerBase
    include Resque::Plugins::Status

    @queue = :crawl

    def perform
      crawl_by_is_control(false)
    end
  end
end