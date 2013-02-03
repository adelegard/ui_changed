module UiChanged
  class Compare < WorkerBase
    include Resque::Plugins::Status

    @queue = :crawl

    def perform
      start_comparing
    end
  end
end