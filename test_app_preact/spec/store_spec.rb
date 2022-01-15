require 'spec_helper'

RSpec.describe 'Stores' do
  before do
    @page = visit('/')
  end

  context 'AppStore' do
    it 'can set and get key/value' do
      @page.eval_ruby do
        AppStore.a_key = 10
        AppStore[:b_key] = 20
      end
      sleep 1 # let store finish updates
      res = @page.eval_ruby do
        AppStore.a_key
      end
      expect(res).to eq(10)
      res = @page.eval_ruby do
        AppStore[:b_key]
      end
      expect(res).to eq(20)
    end

    it 'can handle subscribtions' do
      @page.eval_ruby do
        $received = nil
        $unsub = AppStore.subscribe do
          $received = AppStore.some_value
        end
      end
      @page.eval_ruby do
        AppStore.some_value = 'huhu'
      end
      sleep 1 # let store update
      res = @page.eval_ruby do
        $received
      end
      expect(res).to eq('huhu')
      @page.eval_ruby do
        $received = 0
        AppStore.unsubscribe($unsub)
        AppStore.some_value = 'huhu'
      end
      sleep 1 # let store update
      res = @page.eval_ruby do
        $received
      end
      expect(res).to eq(0)
    end
  end

  context 'SessionStore' do
    it 'can set and get key/value' do
      @page.eval_ruby do
        SessionStore.a_key = 10
        SessionStore[:b_key] = 20
      end
      res = @page.eval_ruby do
        SessionStore.a_key
      end
      expect(res).to eq("10")
      res = @page.eval_ruby do
        SessionStore[:b_key]
      end
      expect(res).to eq("20")
    end

    it 'can delete key' do
      @page.eval_ruby do
        SessionStore.a_key = 10
        SessionStore[:b_key] = 20
      end
      @page.eval_ruby do
        SessionStore.delete(:a_key)
      end
      res = @page.eval_ruby do
        !!SessionStore[:a_key]
      end
      expect(res).to be false
    end

    it 'can clear all' do
      @page.eval_ruby do
        SessionStore.a_key = 10
        SessionStore[:b_key] = 20
      end
      @page.eval_ruby do
        SessionStore.clear
      end
      res = @page.eval_ruby do
        !!SessionStore[:a_key]
      end
      expect(res).to be false
    end

    it 'can handle subscribtions' do
      @page.eval_ruby do
        $received = nil
        $unsub = SessionStore.subscribe do
          $received = SessionStore.some_value
        end
      end
      @page.eval_ruby do
        SessionStore.some_value = 'huhu'
      end
      sleep 1 # let store update
      res = @page.eval_ruby do
        $received
      end
      expect(res).to eq('huhu')
      @page.eval_ruby do
        $received = 0
        SessionStore.unsubscribe($unsub)
        SessionStore.some_value = 'huhu'
      end
      sleep 1 # let store update
      res = @page.eval_ruby do
        $received
      end
      expect(res).to eq(0)
    end
  end

  context 'LocalStore' do
    it 'can set and get key/value' do
      @page.eval_ruby do
        LocalStore.a_key = 10
        LocalStore[:b_key] = 20
      end
      res = @page.eval_ruby do
        LocalStore.a_key
      end
      expect(res).to eq("10")
      res = @page.eval_ruby do
        LocalStore[:b_key]
      end
      expect(res).to eq("20")
    end

    it 'can delete key' do
      @page.eval_ruby do
        LocalStore.a_key = 10
        LocalStore[:b_key] = 20
      end
      @page.eval_ruby do
        LocalStore.delete(:a_key)
      end
      res = @page.eval_ruby do
        !!LocalStore[:a_key]
      end
      expect(res).to be false
    end

    it 'can clear all' do
      @page.eval_ruby do
        LocalStore.a_key = 10
        LocalStore[:b_key] = 20
      end
      @page.eval_ruby do
        LocalStore.clear
      end
      res = @page.eval_ruby do
        !!LocalStore[:a_key]
      end
      expect(res).to be false
    end

    it 'can handle subscribtions' do
      @page.eval_ruby do
        $received = nil
        $unsub = LocalStore.subscribe do
          $received = LocalStore.some_value
        end
      end
      @page.eval_ruby do
        LocalStore.some_value = 'huhu'
      end
      sleep 1 # let store update
      res = @page.eval_ruby do
        $received
      end
      expect(res).to eq('huhu')
      @page.eval_ruby do
        $received = 0
        LocalStore.unsubscribe($unsub)
        LocalStore.some_value = 'huhu'
      end
      sleep 1 # let store update
      res = @page.eval_ruby do
        $received
      end
      expect(res).to eq(0)
    end
  end
end
