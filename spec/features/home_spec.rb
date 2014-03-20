require 'spec_helper'
require "redis"

describe "home page", js: true do
  before :each do
    redis = Redis.new
    redis.set('guest_count', 0)
    redis.set('user_count', 0)
  end
  describe "guests count" do
    it "shows guests count right" do
      in_browser(:one) do
        visit '/'
        expect(page).to have_content '1 strangers in total'
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

  describe "signed in users count" do
    before :all do
      User.destroy_all
      User.create(email: "test1@example.com",
                          password: "password",
                          password_confirmation: "password")
      User.create(email: "test2@example.com",
                          password: "password",
                          password_confirmation: "password")
    end
    it "shows signed in users right" do
      in_browser(:one) do
        visit '/'

        expect(page).to have_content '0 users in all'
        expect(page).to have_content '1 strangers in total'

        click_link 'Sign in'
        fill_in 'Email', with: 'test1@example.com'
        fill_in 'Password', with: 'password'
        click_on 'Sign in'

        expect(page).to have_content '1 users in all'
        expect(page).to have_content '0 strangers in total'
      end

      in_browser(:two) do
        visit '/'
        expect(page).to have_content '1 users in all'
        expect(page).to have_content '1 strangers in total'
        p User.all

        click_link 'Sign in'
        fill_in 'Email', with: 'test2@example.com'
        fill_in 'Password', with: 'password'
        click_on 'Sign in'

        expect(page).to have_content '2 users in all'
        expect(page).to have_content '0 strangers in total'

        click_link 'Home'
        new_window = page.driver.browser.window_handles.last
        page.within_window new_window do
          expect(page).to have_content '2 users in all'
          expect(page).to have_content '0 strangers in total'
          page.execute_script "window.close();"
          # page.driver.browser.close
        end

        visit '/'
        expect(page).to have_content '2 users in all'
        expect(page).to have_content '0 strangers in total'
      end

      in_browser(:one) do
        visit '/'
        expect(page).to have_content '2 users in all'
        expect(page).to have_content '0 strangers in total'
      end

      in_browser(:two) { page.execute_script "window.close();" }

      in_browser(:one) do
        visit '/'
        expect(page).to have_content '1 users in all'
        expect(page).to have_content '0 strangers in total'

        click_link 'Logout'

        expect(page).to have_content '0 users in all'
        expect(page).to have_content '1 strangers in total'
      end
    end
  end
end
