module Lokka
  module Plugin
    module ThemeHelperLoader
      def self.registered(app)
        names = []
        Dir["#{Lokka.root}/public/theme/*/helpers/*_helper.rb"].each do |path|
          path = Pathname.new(path)
          lib = path.parent.parent
          root = lib.parent
          $:.push lib
          name = path.basename.to_s.split('.').first
          require "lokka/#{name}"
          begin
            plugee = ::Lokka.const_get(name.camelize)
            app.register plugee
            names << name
          rescue => e
            puts "plugin #{root} is identified as a suspect."
            puts e
          end
        end
      end
    end
  end
end

