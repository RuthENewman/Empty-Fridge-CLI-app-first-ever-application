require_relative 'config/environment.rb'

class GetUsers

  def self.get_user_name
    puts "Enter Name"
    users_name = gets.chomp
    User.create(name: "#{users_name}")
  end
end
