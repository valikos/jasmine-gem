module Jasmine
  require 'json'
  class SeleniumDriver
    def initialize(browser, http_address)
      require 'selenium-webdriver'

      selenium_server = if Jasmine.config.selenium_server
                          Jasmine.config.selenium_server
                        elsif Jasmine.config.selenium_server_port
                          "http://localhost:#{Jasmine.config.selenium_server_port}/wd/hub"
                        end
      options = if browser == 'firefox-firebug'
                  require File.join(File.dirname(__FILE__), 'firebug/firebug')
                  (profile = Selenium::WebDriver::Firefox::Profile.new)
                  profile.enable_firebug
                  {:profile => profile}
                end || {}
      @driver = if Jasmine.config.webdriver
                  Jasmine.config.webdriver
                elsif selenium_server
                  Selenium::WebDriver.for :remote, :url => selenium_server, :desired_capabilities => browser.to_sym
                else
                  Selenium::WebDriver.for browser.to_sym, options
                end
      @http_address = http_address
    end

    def connect
      @driver.navigate.to @http_address
    end

    def disconnect
      @driver.quit
    end

    def eval_js(script)
      @driver.execute_script(script)
    end

  end
end
