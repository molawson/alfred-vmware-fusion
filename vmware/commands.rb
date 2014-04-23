require './vmware/queries'
require './vmware/output'

module Vmware
  module Commands

    include Queries
    include Output

    def start(vm)
      %x("#{vmrun}" start "#{vm}" nogui)
      vm_details vm
    end

    def suspend(vm)
      %x("#{vmrun}" suspend "#{vm}")
      vm_details vm
    end

    def list_running
      list find_running
    end

    def list_idle(search_paths)
      list find_idle(search_paths)
    end

    def vmrun
      raise NotImplementedError, "The `vmrun` method must be implemented by the class that includes Vmware::Commands"
    end

  end
end
