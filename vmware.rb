require 'find'

@vmrun = '/Applications/VMware Fusion.app/Contents/Library/vmrun'

def start(vm)
  %x("#{@vmrun}" start "#{vm}" nogui)
  vm_details vm
end

def suspend(vm)
  %x("#{@vmrun}" suspend "#{vm}")
  vm_details vm
end

def list
  vms = []

  result = %x("#{@vmrun}" list)
  result.lines.each_with_index do |line, i|
    next unless line.match "/"
    vms << vm_details(line).merge({ :uid => "vmup-#{i}" })
  end

  build_items vms
end

def find(search_path)
  paths = []
  running_paths = []
  vms = []

  Find.find(search_path) do |path|
    paths << path if path =~ /.*\.vmwarevm$/
  end

  result = %x("#{@vmrun}" list)
  result.lines.each do |line|
    if line.match "/"
      running_paths << line.match(/^(.+\.vmwarevm)\/.+$/)[1]
    end
  end

  (paths - running_paths).each_with_index do |path, i|
    vms << vm_details(path).merge({ :uid => "vmdown-#{i}" })
  end

  build_items vms
end

def build_items(items)
  xml = <<-EOF
  <?xml version="1.0"?>
  <items>
  EOF

  if items.empty?
    none = {
      :uid => "vm-none",
      :name => "none",
      :path => "There are no VMs to display"
    }
    xml << build_item(none)
  else
    items.each { |item| xml << build_item(item) }
  end

  xml << <<-EOF
  </items>
  EOF
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

def vm_details(vm)
  name_chunks = vm.split('/').last.split('.')
  extension = name_chunks.pop
  name = name_chunks.join('.')
  path = vm.strip
  { :name => name, :path => path }
end
