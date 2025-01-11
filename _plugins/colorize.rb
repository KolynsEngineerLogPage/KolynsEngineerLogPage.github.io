module Jekyll
    module Colorize
    def colorize(input, color)
    "<span style='color: #{color};'>#{input}</span>"
    end
end
end

Liquid::Template.register_filter(Jekyll::Colorize)


# {{ "This text is red" | colorize: "red" }}
