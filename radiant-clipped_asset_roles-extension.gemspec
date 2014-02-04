# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "radiant-clipped_asset_roles-extension"

Gem::Specification.new do |s|
  s.name        = "radiant-clipped_asset_roles-extension"
  s.version     = RadiantClippedAssetRolesExtension::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = RadiantClippedAssetRolesExtension::AUTHORS
  s.email       = RadiantClippedAssetRolesExtension::EMAIL
  s.homepage    = RadiantClippedAssetRolesExtension::URL
  s.summary     = RadiantClippedAssetRolesExtension::SUMMARY
  s.description = RadiantClippedAssetRolesExtension::DESCRIPTION

  # Define gem dependencies here.
  # Don't include a dependency on radiant itself: it causes problems when radiant is in vendor/radiant.
  # s.add_dependency "something", "~> 1.0.0"
  s.add_dependency "radiant-clipped-extension", "~> 1.0.16"

  ignores = if File.exist?('.gitignore')
    File.read('.gitignore').split("\n").inject([]) {|a,p| a + Dir[p] }
  else
    []
  end
  s.files         = Dir['**/*'] - ignores
  s.test_files    = Dir['test/**/*','spec/**/*','features/**/*'] - ignores
  # s.executables   = Dir['bin/*'] - ignores
  s.require_paths = ["lib"]
end
