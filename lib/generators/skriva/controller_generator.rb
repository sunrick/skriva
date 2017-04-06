class Skriva::ControllerGenerator < Rails::Generators::Base
  def create_controller_file
    create_file(
      "app/controllers/skriva/posts_controller.rb",
      File.read(
        Skriva::Engine.root.join('app','controllers','skriva', 'posts_controller.rb')
      )
    )
  end
end
