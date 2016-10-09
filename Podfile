platform :ios, '9.2'
use_frameworks!
inhibit_all_warnings!

def general_pods
  pod 'Moya', '8.0.0-beta.2'
  pod 'Moya/ReactiveCocoa'
  pod 'ReactiveSwift', '1.0.0-alpha.2'
  pod 'Argo', :git => 'https://github.com/thoughtbot/Argo.git'
  pod 'Curry', :git => 'https://github.com/thoughtbot/Curry.git'
  pod 'Runes', :git => 'https://github.com/thoughtbot/Runes.git'
  pod "HanekeSwift", :git => 'https://github.com/Haneke/HanekeSwift.git', :branch => 'feature/swift-3'
end

target 'ReactivePokemon' do
  general_pods
end

target 'ReactivePokemonTests' do
  general_pods
  pod 'Quick'
  pod 'Nimble'
end

