# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

Rails.application.config.assets.precompile += %w(jquery-3.3.1.min.js)
Rails.application.config.assets.precompile += %w(bootstrap.min.js)
Rails.application.config.assets.precompile += %w(jquery-3.3.1.min.jsjquery.nice-select.min.js)
Rails.application.config.assets.precompile += %w(jquery-ui.min.js)
Rails.application.config.assets.precompile += %w(jquery.slicknav.js)
Rails.application.config.assets.precompile += %w(mixitup.min.js)
Rails.application.config.assets.precompile += %w(owl.carousel.min.js)
Rails.application.config.assets.precompile += %w(main.js)
# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )
