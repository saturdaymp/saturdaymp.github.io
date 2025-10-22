# Plugin to dynamically add Bootstrap gem path to Sass load paths
Jekyll::Hooks.register :site, :after_init do |site|
  begin
    # Find the Bootstrap gem specification
    bootstrap_gem = Gem::Specification.find_by_name('bootstrap')

    # Get the path to the Bootstrap stylesheets
    bootstrap_stylesheets_path = File.join(bootstrap_gem.gem_dir, 'assets', 'stylesheets')

    # Add to Sass load paths if it exists
    if File.directory?(bootstrap_stylesheets_path)
      site.config['sass'] ||= {}
      site.config['sass']['load_paths'] ||= []
      site.config['sass']['load_paths'] << bootstrap_stylesheets_path

      Jekyll.logger.info "Bootstrap Gem:", "Added load path: #{bootstrap_stylesheets_path}"
    else
      Jekyll.logger.warn "Bootstrap Gem:", "Stylesheets directory not found at: #{bootstrap_stylesheets_path}"
    end
  rescue Gem::MissingSpecError
    Jekyll.logger.error "Bootstrap Gem:", "Bootstrap gem not found. Please ensure it's installed."
  end
end
