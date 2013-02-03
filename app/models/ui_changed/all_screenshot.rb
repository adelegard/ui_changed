module UiChanged
  class AllScreenshot
    attr_accessor :control_ss, :test_ss, :diff_ss

    def initialize(control_ss, test_ss, diff_ss)
      @control_ss = control_ss
      @test_ss = test_ss
      @diff_ss = diff_ss
    end
  end
end