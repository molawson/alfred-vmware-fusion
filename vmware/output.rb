module Vmware
  module Output

    private

    def list(vms)
      details = details_for(vms)
      build_items details
    end

    def details_for(vms)
      details = []
      Array(vms).each_with_index do |vm, i|
        details << vm_details(vm).merge({ :uid => "vmdown-#{i}" })
      end
      details
    end

    def vm_details(vm)
      name_chunks = vm.split('/').last.split('.')
      extension = name_chunks.pop
      name = name_chunks.join('.')
      path = vm.strip
      { :name => name, :path => path }
    end

    def build_items(items)
      xml = <<-EOF
  <?xml version="1.0"?>
  <items>
      EOF

      if items.empty?
        xml << build_item(none)
      else
        items.each { |item| xml << build_item(item) }
      end

      xml << <<-EOF
  </items>
      EOF
    end

    def none
      {
        :uid => "vm-none",
        :name => "none",
        :path => "There are no VMs to display"
      }
    end

    def build_item(item)
      <<-EOF
  <item uid="#{item[:uid]}" arg="#{item[:name]}:#{item[:path]}" valid="yes">
    <title>#{item[:name]}</title>
    <subtitle>#{item[:path]}</subtitle>
    <icon>icon.png</icon>
  </item>
      EOF
    end

  end
end
