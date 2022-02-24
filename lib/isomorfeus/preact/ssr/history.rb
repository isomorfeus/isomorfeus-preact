module Browser
  class History
    def back; end
    def forward; end
    def go(a); end

    def length
      0
    end
    alias :size :length

    def push_state(state, title = '', url = nil); end
    def replace_state(state, title = '', url = nil); end
    def scroll_restoration; end
    def scroll_restoration=(s); end

    def state
      {}
    end
  end
end

Isomorfeus.browser_history = Browser::History.new
