require File.join(File.dirname(__FILE__), 'helpers', 'common')

ActionView::Base.send(:include, StwEngine::Helpers::Common) if defined? ActionView
