#
#  rb_main.rb
#  ITranslate
#
#  Created by ROGERIO ARAUJO on 07/09/09.
#  Copyright (c) 2009 BMobile. All rights reserved.
#

require 'osx/cocoa'
require 'Services'

def rb_main_init
  path = OSX::NSBundle.mainBundle.resourcePath.fileSystemRepresentation
  rbfiles = Dir.entries(path).select {|x| /\.rb\z/ =~ x}
  rbfiles -= [ File.basename(__FILE__) ]
  rbfiles.each do |path|
    require( File.basename(path) )
  end
end

if $0 == __FILE__ then
  rb_main_init
  services = Services.alloc.init
  OSX.NSRegisterServicesProvider(services, "ITranslate")
  OSX.NSUpdateDynamicServices()
  OSX.NSApplicationMain(0, nil)
end
