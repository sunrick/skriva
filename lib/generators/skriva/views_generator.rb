class Skriva::ViewsGenerator < Rails::Generators::Base
  def create_controller_file
    Dir[Skriva::Engine.root.join('app','views','skriva','posts', '*')].each do |file|
      create_file(
        "app/views/skriva/posts/#{File.basename(file)}",
        File.read(file)
      )
    end
  end
end
