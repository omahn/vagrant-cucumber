FORCE_COLOUR_ENV_VARS = %w(
    VAGRANT_CUCUMBER_FORCE_COLOR
    VAGRANT_CUCUMBER_FORCE_COLOUR
).freeze

module VagrantPlugins
    module Cucumber
        class CucumberCommand < Vagrant.plugin(2, :command)
            FORCE_COLOUR_ENV_VARS.each do |k|
                next unless ENV.key?(k)
                require 'cucumber/term/ansicolor'
                ::Cucumber::Term::ANSIColor.coloring = true
                break
            end

            def execute
                require 'cucumber/rspec/disable_option_parser'
                require 'cucumber/cli/main'

                require 'vagrant-cucumber/cucumber/formatter/pretty'
                require 'vagrant-cucumber/cucumber/formatter/html'
                require 'vagrant-cucumber/glue'

                VagrantPlugins::Cucumber::Glue::VagrantGlue.set_environment(@env)

                _ = ::Cucumber::Cli::Main.execute(@argv)
            end
        end
    end
end
