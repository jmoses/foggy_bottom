module FoggyBottom
  class Api
    attr_accessor :token, :url, :endpoint
    attr_reader :logger

    def initialize( url, username, password )
      @logger = Logger.new(STDOUT).tap {|l| l.level = Logger::DEBUG }
      @url = url[-1] == '/' ? url : "#{url}/"

      token_filename = File.expand_path( "~/.foggy_bottom_token_" + Digest::SHA2.hexdigest("#{username}_#{password}") )

      if File.exists?(token_filename)
        load_details(token_filename)
      else
        fetch_endpoint
        fetch_token(username, password, token_filename)
      end
    end

    def exec(cmd, args = {})
      get(build_url(cmd, args))
    end

    def find( issue_id )
      Case.find(issue_id, self)
    end
    alias :[] :find

    protected
      def fetch_token(username, password, token_filename)
        @token ||= begin
          logger.debug("Fetching token")
          get(build_url(:logon, :email => username, :password => password)).at_css("response token").content.tap do |token|
            logger.debug(" done.")
            save_token(token, token_filename)
          end
        end  
      end

      def load_details(token_filename)
        logger.debug("Loading cached credentials")

        @endpoint, @token = File.read(token_filename).split("\n").map(&:strip)
      end

      def save_token(token, token_filename)
        logger.debug("Caching token")

        File.open(token_filename, 'w') do |out|
          out << endpoint
          out << "\n"
          out << token
        end
      end

      def fetch_endpoint
        @endpoint ||= begin
          logger.debug("Fetching endpoint")
          Nokogiri.XML( open("#{url}/api.xml") {|f| f.read } ).at_css("response url").content
        end
      end

      def get(path)
        logger.debug("Attempting to access: #{path}")
        Nokogiri.XML( open(path) {|f| f.read } )
      end

      def build_url(cmd, args)
        url + endpoint + args.merge(:cmd => cmd.to_s, :token => token).inject([]) {|memo, (key, value)| memo << "#{key}=#{CGI.escape(value.to_s)}" }.join("&")
      end
  end
end
