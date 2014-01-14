Pod::Spec.new do |s|
  s.name         = "CVSearchTableViewController"
  s.version      = "0.1"
  s.summary      = "A table view controller that helps you search through it's contents."

  s.description  = <<-DESC
    CVSearchTableViewController is a quick way to get your users searching through the contents of a table view.

    Easy setup. If you use storyboards you never have to subclass CVSearchTableViewController.
    Implements UISearchDisplayControllerDelegate and UISearchBarDelegate. You never have to mess with reloading the table view when the user searches.
  DESC

  s.homepage     = "https://github.com/kaspth/CVSearchTableViewController"
  s.license      = 'MIT'
  s.author       = { "Kasper Timm Hansen" => "kaspth@gmail.com" }
  s.platform     = :ios, '7.0'

  s.source       = { :git => "https://github.com/kaspth/CVSearchTableViewController.git", :tag => "0.1" }
  s.source_files  = '*.{h,m}'

  s.requires_arc = true
  s.dependency 'CVArrayTableViewController', '~> 0.2'
  s.dependency 'CVPredicateFilter',          '~> 0.1'
end
