# Warn when there is a big PR
warn("Big PR") if git.lines_of_code > 500

xcov.report(
  workspace: 'RSignatureVerifier.xcworkspace',
  scheme: 'UnitTests',
  output_directory: 'artifacts/unit-tests/coverage',
  source_directory: 'RSignatureVerifier',
  json_report: true,
  include_targets: 'RSignatureVerifier.framework',
  include_test_targets: false,
  minimum_coverage_percentage: 60.0
)
