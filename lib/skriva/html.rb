module Skriva
  class HTML < Redcarpet::Render::HTML
    include Rouge::Plugins::Redcarpet # yep, that's it.
  end
end
