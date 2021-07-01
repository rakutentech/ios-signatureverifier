platform :ios, '11.0'
use_frameworks!

secrets = ["RSV_KEY_FETCH_ENDPOINT", "RAS_SUBSCRIPTION_KEY"]

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

