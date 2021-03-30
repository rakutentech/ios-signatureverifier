platform :ios, '11.0'
use_frameworks!


target 'SampleApp' do
  pod 'RSignatureVerifier', :path => './RSignatureVerifier.podspec'
  pod 'SwiftLint'

  target 'Tests' do
    target 'UnitTests'
    target 'IntegrationTests'
    pod 'Quick'
    pod 'Nimble'
  end
end
