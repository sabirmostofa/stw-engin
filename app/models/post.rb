class Post < ActiveRecord::Base
  unless Rails::VERSION::MAJOR >= 4
    attr_accessible :text, :title
  end
end
