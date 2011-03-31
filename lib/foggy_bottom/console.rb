class FoggyBottom::Console
  delegate :logger, :to => :api

  attr_accessor :api
  def initialize(api)
    @api = api
  end

  def run
    while( cmd = show_menu ) do
      case cmd
      when :search
        search(get("Terms"))
      when :quit
        exit 0
      else
        puts " Unknown choice"
      end
    end
  end

  protected
    def show_menu
      commands = %w( search quit )
      choice = (Hirb::Menu.render commands, :helper_class => false, :directions => false).first
      choice ? choice.to_sym : :unknown 
    end

    def choose( arguments, options = {})
      Hirb::Menu.render arguments, options.merge(:helper_class => false)
    end

    def get(prompt)
      STDOUT.write "#{prompt}: "
      STDOUT.flush
      STDIN.gets.chomp
    end

    def search(terms)
      unless terms
        puts "Search terms are required."
        return
      end

      cases = api.search(terms)
      choose(cases.map(&:to_s))
    end
end
