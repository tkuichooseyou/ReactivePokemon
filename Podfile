platform :ios, '9.2'
use_frameworks!
inhibit_all_warnings!

def general_pods
  pod 'Moya/ReactiveCocoa'
  pod 'Argo'
  pod 'Curry'
  pod 'HanekeSwift'
end

target 'ReactivePokemon' do
  general_pods
end

target 'ReactivePokemonTests' do
  general_pods
  pod 'Quick'
  pod 'Nimble'
end

