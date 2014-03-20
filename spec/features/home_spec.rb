require 'spec_helper'
require "redis"

describe "home page", js: true do
  before :all do
    @redis ||= Redis.new
  end
  before :each do
    @redis.set('guest_count', 0)
  end

  describe "guests count" do
    it "shows guests count right" do
      in_browser(:one) do
        visit '/'
        expect(page).to have_content '1 strangers in total'

        click_link 'Home'
        new_window = page.driver.browser.window_handles.last
        page.within_window new_window do
          expect(page).to have_content '1 strangers in total'
        end
      end
      in_browser(:two) do
        visit '/'
        expect(page).to have_content '2 strangers in total'

        click_link 'Home'
        new_window = page.driver.browser.window_handles.last
        page.within_window new_window do
          expect(page).to have_content '2 strangers in total'
          page.execute_script "window.close();"
        end

        visit '/'
        expect(page).to have_content '2 strangers in total'
      end
      in_browser(:one) do
        visit '/'
        expect(page).to have_content '2 strangers in total'
      end
      in_browser(:two) { page.execute_script "window.close();" }
      in_browser(:one) do
        visit '/'
        expect(page).to have_content '1 strangers in total'
      end
    end
  end
end
