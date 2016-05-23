Pod::Spec.new do |s|
  s.default_subspec = 'Core'
  s.name         = "SignalR-ObjC"
  s.version      = "1.0.1"
  s.summary      = "This is a duplicate of project(https://github.com/DyKnow/SignalR-ObjC.git). I have updated this project to support AFNetworking 3.0"
  s.homepage     = "https://github.com/maheshverma/SamplePod"
  s.license      = 'MIT'
  s.author       = { "Mahesh Verma" => "maheshsearch01@gmail.com" }
  s.source   	 = { 
	:git => 'https://github.com/maheshverma/SamplePod.git', \
	:tag => '1.0.1' }
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'
  s.requires_arc = true

  s.subspec 'Core' do |sp|
    sp.source_files = 'Framework/*.{h}', 'SignalR.Client/**/*.{h,m}'
    sp.dependency 'AFNetworking', '~>3.0'
    sp.dependency 'SocketRocket', '~>0.4'
  end

  s.subspec 'CocoaLumberjack' do |sp|
    sp.dependency 'CocoaLumberjack', '~>1.0'
    sp.dependency 'SignalR-ObjC/Core'
  end
end
