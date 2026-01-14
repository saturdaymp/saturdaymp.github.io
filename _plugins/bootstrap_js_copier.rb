# Plugin to copy Bootstrap JavaScript from gem to site assets
Jekyll::Hooks.register :site, :after_init do |site|
  begin
    bootstrap_gem = Gem::Specification.find_by_name('bootstrap')

    # Source: Bootstrap gem's JavaScript directory
    bootstrap_js_src = File.join(bootstrap_gem.gem_dir, 'assets', 'javascripts')

    # Destination: Site's assets/js directory
    bootstrap_js_dest = File.join(site.source, 'assets', 'js', 'vendor')

    # Create destination directory if it doesn't exist
    FileUtils.mkdir_p(bootstrap_js_dest)

    # List of possible Bootstrap bundle files to look for (in order of preference)
    possible_files = [
      'bootstrap.bundle.min.js',
      'bootstrap.bundle.js',
      'bootstrap.min.js',
      'bootstrap.js',
      'bootstrap/bootstrap.bundle.min.js',
      'bootstrap/bootstrap.bundle.js',
      'bootstrap/bootstrap.min.js',
      'bootstrap/bootstrap.js'
    ]

    copied = false
    possible_files.each do |filename|
      source_file = File.join(bootstrap_js_src, filename)
      if File.exist?(source_file)
        # Copy to destination with standardized name
        dest_filename = filename.include?('bundle') ? 'bootstrap.bundle.min.js' : 'bootstrap.min.js'
        FileUtils.cp(source_file, File.join(bootstrap_js_dest, dest_filename))
        Jekyll.logger.info "Bootstrap JS:", "Copied #{filename} to assets/js/vendor/#{dest_filename}"
        copied = true
        break
      end
    end

    unless copied
      # List all available JS files for debugging
      Jekyll.logger.warn "Bootstrap JS:", "No Bootstrap JS files found. Available files in gem:"
      Dir.glob(File.join(bootstrap_js_src, '**', '*')).each do |f|
        Jekyll.logger.info "Bootstrap JS:", "  #{f}"
      end
    end
  rescue Gem::MissingSpecError
    Jekyll.logger.error "Bootstrap JS:", "Bootstrap gem not found."
  rescue => e
    Jekyll.logger.error "Bootstrap JS:", "Error copying files: #{e.message}"
  end
end
