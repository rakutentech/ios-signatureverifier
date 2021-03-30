# https://github.com/jcampbell05/xcake
# http://www.rubydoc.info/github/jcampbell05/xcake/master/file/docs/Cakefile.md

iOSdeploymentTarget = "11.0"
currentSwiftVersion = "5.3"
companyIdentifier = "com.rakuten.tech"
project.name = "RSignatureVerifier"
project.organization = "Rakuten Group, Inc."

project.all_configurations.each do |configuration|
    configuration.settings["CURRENT_PROJECT_VERSION"] = "1" # just default non-empty value
    configuration.settings["SWIFT_OPTIMIZATION_LEVEL"] = "-Onone"
    configuration.settings["ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES"] = "$(inherited)" # "YES"
    configuration.settings["SWIFT_VERSION"] = currentSwiftVersion
end

target do |target|

    target.name = "SampleApp"
    target.language = :swift
    target.type = :application
    target.platform = :ios
    target.deployment_target = iOSdeploymentTarget
    target.scheme(target.name)

    target.all_configurations.each do |configuration|
        configuration.product_bundle_identifier = companyIdentifier + "." + target.name
        configuration.supported_devices = :universal
        configuration.settings["INFOPLIST_FILE"] = "Sample/Info.plist"
        configuration.settings["PRODUCT_NAME"] = "$(TARGET_NAME)"
    end

    target.include_files = ["Sample/**/*.*"]
    # target.include_files << "Res/**/*.*"  # add another value

    unit_tests_for target do |unit_test_target|

        unit_test_target.name = "UnitTests"
        unit_test_target.scheme(unit_test_target.name) do |scheme|
            scheme.test_configuration = "Debug"
        end

        unit_test_target.all_configurations.each do |configuration|
            configuration.settings["INFOPLIST_FILE"] = "Tests/Unit/" + unit_test_target.name + "-Info.plist"
        end

        unit_test_target.include_files = ["Tests/Unit/*.swift"]

    end

    unit_tests_for target do |integration_test_target|

        integration_test_target.name = "IntegrationTests"
        integration_test_target.scheme(integration_test_target.name) do |scheme|
            scheme.test_configuration = "Debug"
        end

        integration_test_target.all_configurations.each do |configuration|
            configuration.settings["INFOPLIST_FILE"] = "Tests/Integration/" + integration_test_target.name + "-Info.plist"
        end

        integration_test_target.include_files = ["Tests/Integration/*.swift"]

    end

    unit_tests_for target do |test_target|

        test_target.name = "Tests"
        test_target.scheme(test_target.name) do |scheme|
            scheme.test_configuration = "Debug"
        end

        test_target.all_configurations.each do |configuration|
            configuration.settings["INFOPLIST_FILE"] = "Tests/" + test_target.name + "-Info.plist"
        end

        test_target.include_files = ["Tests/Unit/*.swift", "Tests/Integration/*.swift"]

    end

end