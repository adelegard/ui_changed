module UiChanged
  class CrawlControl < WorkerBase
    include Resque::Plugins::Status

    @queue = :crawl

    def perform
      crawl_by_is_control(true)
    end
  end
end