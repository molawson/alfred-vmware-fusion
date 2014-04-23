module Vmware
  module Queries

    def vmrun
      raise NotImplementedError, "The `vmrun` method must be implemented by the class that includes Vmware::Queries"
    end

    private

    def find_running
      output = %x("#{vmrun}" list).lines
      output.map { |l| l.match(/^(.+\.vmwarevm)\/.+$/) && $1 }.compact
    end

    def find_idle(search_paths)
      find_running
      find_all(search_paths) - find_running
    end

    def find_all(search_paths)
      Array(search_paths).reduce([]) do |paths, search_path|
        find_in_dir(search_path) { |path| paths << path }
        paths
      end
    end

    def find_in_dir(dir)
      if Dir.exist?(dir) && Dir.chdir(dir)
        Dir.glob('*.vmwarevm') { |p| yield File.join(dir, p) }
      end
    end

  end
end
