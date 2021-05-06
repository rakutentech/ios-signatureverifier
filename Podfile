platform :ios, '11.0'
use_frameworks!

secrets = ["RSV_KEY_FETCH_ENDPOINT", "RAS_APPLICATION_IDENTIFIER", "RAS_SUBSCRIPTION_KEY"]

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

post_install do |installer|
  # secure xcconfig variables config
  system("./scripts/configure-secrets.sh SignatureVerifier #{secrets.join(" ")}")
end
