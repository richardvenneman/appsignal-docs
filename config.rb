###
# Blog settings
###

DOCS_ROOT   = File.expand_path(File.dirname(__FILE__))
GITHUB_ROOT = "https://github.com/appsignal/appsignal-docs/tree/master"

Time.zone = "Amsterdam"

set :layout, :article

set(
  :markdown,
  :tables             => true,
  :autolink           => true,
  :gh_blockcode       => true,
  :fenced_code_blocks => true,
  :with_toc_data      => true,
  :smarty_pants       => true
)
set :markdown_engine, :redcarpet

###
# HAML
###

set :haml, { :attr_wrapper => "\"" }

###
# GZIP
###

activate :gzip

###
# SYNTAX HIGHLIGHTING
###

activate :syntax

###
# Compass
###

# Susy grids in Compass
# First: gem install susy
# require 'susy'

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy (fake) files
# page "/this-page-has-no-template.html", :proxy => "/template-file.html" do
#   @which_fake_page = "Rendering a fake page with a variable"
# end

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

helpers do
  def link_with_active(name, path)
    link_to(
      name,
      path,
      :class => ('active' if path == "/#{request.path}")
    )
  end

  def edit_link
    page_path = current_page.source_file
    link_to('Create a pull request', page_path.gsub(DOCS_ROOT, GITHUB_ROOT))
  end
end
set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript

  # Enable cache buster
  activate :cache_buster

  # Use relative URLs
  # activate :relative_assets

  # Compress PNGs after build
  # First: gem install middleman-smusher
  # require "middleman-smusher"
  # activate :smusher

  # Or use a different image path
  # set :http_path, "/Content/images/"
end

activate :s3_sync do |s3|
  s3.aws_access_key_id     = ENV['AWS_DOCS_ID']
  s3.aws_secret_access_key = ENV['AWS_DOCS_KEY']
  s3.bucket                = ENV['AWS_DOCS_BUCKET']
  s3.region                = 'eu-west-1'
  s3.prefer_gzip           = true
end

activate :cloudfront do |cf|
  cf.access_key_id     = ENV['AWS_DOCS_ID']
  cf.secret_access_key = ENV['AWS_DOCS_KEY']
  cf.distribution_id   = ENV['AWS_DOCS_CF']
end
