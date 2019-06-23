#
#  Be sure to run `pod spec lint DPEdgeMenu.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "DPEdgeMenu"
  s.version      = "0.1.1"
  s.summary      = "edge menu"

  s.description  = <<-DESC
                    simple menu appear from four directions of screen edge 
                    DESC

  s.homepage     = "https://github.com/HongliYu/DPEdgeMenu-Swift"
  s.license      = "MIT"
  s.author       = { "HongliYu" => "yhlssdone@gmail.com" }
  s.source       = { :git => "https://github.com/HongliYu/DPEdgeMenu-Swift.git", :tag => "#{s.version}" }

  s.platform     = :ios, "10.0"
  s.requires_arc = true
  s.source_files = "DPEdgeMenuDemo/DPEdgeMenu/"
  s.frameworks   = 'UIKit', 'Foundation'
  s.module_name  = 'DPEdgeMenu'
  s.swift_version = "5.0"

end
