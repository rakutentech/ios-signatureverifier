Pod::Spec.new do |s|
  s.name         = "RSignatureVerifier"
  s.version      = "0.1.0"
  s.authors      = "Rakuten Ecosystem Mobile"
  s.summary      = "Rakuten's Signature Verifier module."
  s.homepage     = "https://github.com/rakutentech/ios-signatureverifier"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.source       = { :git => "https://github.com/rakutentech/ios-signatureverifier.git", :tag => s.version.to_s }
  s.platform     = :ios, '13.0'
  s.swift_version = '5.3'
  s.documentation_url = "https://rakutentech.github.io/ios-signatureverifier/"
  s.weak_frameworks = [
    'Foundation',
  ]
  s.source_files = "RSignatureVerifier/**/*.{Swift,m}"
end
