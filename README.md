# VMware Fusion Alfred Workflow

From time to time, I need to run a virtual machine or two on my Mac. [VMware Fusion](http://www.vmware.com/products/fusion/) has always been my favorite app for making that happen. For a while, I went through the normal open the app, click the button to start the VM, click the button to suspend the VM when finished, etc., etc., routine.

The problem is, I don't always need to use the VM's GUI. More often than not, I'm using the VM as a server for some sort of development (e.g. a SQL Server instance). And let's be honest, after you've used [Alfred]() for a little while, you realize just how much time the "old you"  wasted pointing and clicking. As an avid Alfred and vim user, I say, "Why use the mouse when you could just use the keyboard?"

As it turns out, VMware Fusion includes a little-known (at least to me at the time) CLI called `vmrun` that can be used to start and suspend VMs to your heart's content. Best of all, you can even start VMs in a "headless" mode, where not even the VMware Fusion app is visible.  I've taken that utility and sprinkled a little Ruby on top to create this workflow that has markedly improved my development workflow.

## Usage

Currently, there are just three simple commands.

![commands](http://mola.ws/image/2W2a1j1z1B1r/commands.jpg)

### Start

Start any VM.

![start](http://mola.ws/image/0T110s0n2W3M/start.gif)

### Suspend

Suspend any running VM.

![suspend](http://mola.ws/image/3W0g2i2p301b/suspend.gif)

### List

List all running VMs.

![list](http://mola.ws/image/373O2S082f2G/list.gif)


## Installation

Once you have Alfred installed, along with the [Powerpack](http://www.alfredapp.com/powerpack/), you can download the [latest release](https://github.com/molawson/alfred-vmware-fusion/releases/latest) of the workflow file, and double click it to install.

## Assumptions

### VMware Fusion location

The workflow assumes that you have `VMware Fusion.app` installed in the default location, `/Applications`. Since the `vmrun` tool lives withing the app package, it uses this default to issue commands.

If you have it installed somewhere else, you'll need to edit the workflow script. To do that, in Alfred preferences, find the VMware Fusion workflow and double click on any of the squares within the workflow. Near the bottom right of the window that appears, there's a button that says "Open workflow folder."  Click that and you're looking for the `vmware/alfred.rb` file. Change the following line to point to your `vmrun` location:
```ruby
@vmrun = '/Applications/VMware Fusion.app/Contents/Library/vmrun'
```

### Virtual Machine location(s)

For the `vm start` command to work, the workflow needs to know where you keep your VMware images. The default location is `~/Documents/Virtual Machines`.

If you have your VMs somewhere else, you can edit the default from within the Alfred preferences. Open Alfred preferences, find the VMware Fusion workflow, and double click on the box for the `vm start` command. The window that appears will have a few lines that look like this:
```ruby
search_paths = [
  File.expand_path('~/Documents/Virtual Machines'),
]
```
You can edit the `~/Documents/Virtual Machines` part to point to the directory that contains your VMs Since this is a plain old Ruby array, you can also add more locations. 

**NB:** The workflow _does not_ search directories recursively (i.e. look in subdirectories). It simply looks for files ending in ".vmware" in the directories listed.
