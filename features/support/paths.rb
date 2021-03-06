module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /^the home\s?page$/
      '/'


    when /the delivery "(.*)"$/i
      delivery_path(Delivery.find_by_name($1), :farm_id => @farm.id)

    when /the farm "(.*)"$/i
      farm_path(Farm.find_by_name($1))

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))
      when /the farm "(.*)"$/i
        farm_path(Farm.find_by_name($1))

      else
        begin
          path_components =
              if page_name =~ /the (.*) page/
                $1.split(/\s+/)\
              else
                page_name.split(/\s+/)
              end
        self.send(path_components.push('path').join('_').to_sym)
      rescue NoMethodError, ArgumentError
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
