require './vmware'

module Vmware
  class Alfred

    include Commands

    attr_reader :vmrun

    def initialize
      @vmrun = '/Applications/VMware Fusion.app/Contents/Library/vmrun'
    end

    def self.start(vm)
      new.start vm
    end

    def self.suspend(vm)
      new.suspend vm
    end

    def self.list_running
      new.list_running
    end

    def self.list_idle(search_paths)
      new.list_idle search_paths
    end

  end
end
