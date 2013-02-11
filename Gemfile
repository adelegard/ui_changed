source :rubygems

gemspec

group :active_record do
  platforms :ruby, :mswin, :mingw do
    case ENV['CI_DB_ADAPTER']
    when 'mysql2'
      gem 'mysql2'
    when 'postgresql'
      gem 'pg', '~> 0.13'
    else
      gem 'sqlite3', '~> 1.3'
    end
  end
end
