require "log4r"

module VagrantPlugins
  module HyperV
    module Action
      class ReadState
        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant::hyperv::connection")
        end

        def call(env)
          if env[:machine].id
            options = { VmId: env[:machine].id }
            response = env[:machine].provider.driver.execute('get_vm_status.ps1', options)
            env[:machine_state_id] = response["state"].downcase.to_sym
          else
            env[:machine_state_id] = :not_created
          end
          @app.call(env)
        end
      end
    end
  end
end
