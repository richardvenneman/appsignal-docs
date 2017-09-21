require "dotenv"
require "lib/appsignal_markdown"

Dotenv.load

DOCS_ROOT   = File.expand_path(File.dirname(__FILE__))
GITHUB_ROOT = "https://github.com/appsignal/appsignal-docs/tree/master"

Time.zone = "Amsterdam"

set :layout, :article
set :markdown_engine, :redcarpet
set :markdown, AppsignalMarkdown::OPTIONS.merge(renderer: AppsignalMarkdown)
set :haml, :attr_wrapper => %(")
set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'

activate :syntax, :line_numbers => true

helpers do
  def link_with_active(*args, &block)
    if block_given?
      path, options = args
    else
      name, path, options = args
    end
    options ||= {}
    options[:class] = options[:class].to_s
    options[:class] += " active" if path == current_page.url

    new_args =
      if block_given?
        [path, options]
      else
        [name, path, options]
      end
    link_to(
      *new_args,
      &block
    )
  end

  def edit_link
    page_path = current_page.source_file
    link_to(
      'Create a pull request',
      page_path.gsub(DOCS_ROOT, GITHUB_ROOT),
      :class => 'button tiny outline-white'
    )
  end
end

configure :build do
  activate :gzip
  activate :minify_css
  activate :cache_buster
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
