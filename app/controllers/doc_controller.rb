class DocController < ApplicationController
  caches_page :index, :show

  def index
  end

  def show
    render_doc_page params[:doc], params[:page]
  end

  protected

  def render_doc_page(doc_name, page_name)
    x = process_doc_page(doc_name, page_name)
    if x.nil?
      redirect_to :action => 'index' 
    else
      render :text => x, :layout => true
    end
  end

  def process_doc_page(doc_name, page_name)
    x = load_doc_page(doc_name, page_name)
    
    # Convert from bare-minimum code.google.com wiki format to html,
    # where ordering of these regexps is important.
    #
    # TODO: One day just convert all the wiki pages to haml?
    #
    x = x.gsub(/^$/, '<p/>') 
    x = x.gsub(/^http:([^ ]+?)$/, "<a href=\"http:\\1\">http:\\1</a>")
    x = x.gsub(/ http:([^ ]+?)$/, " <a href=\"http:\\1\">http:\\1</a>")
    x = x.gsub(/ http:([^ ]+?) /, " <a href=\"http:\\1\">http:\\1</a> ")
    x = x.gsub(/\[http:([^ ]+?) ([^\]]+?)\]/, "<a href=\"http:\\1\">\\2</a>")
    x = x.gsub(/\[([^\] ]+?)\]/,              "<a href=\"/doc/#{doc_name}/\\1\">\\1</a>")
    x = x.gsub(/\[([^ ]+?) ([^\]]+?)\]/,      "<a href=\"/doc/#{doc_name}/\\1\">\\2</a>")
    x = x.gsub(/^#summary (.*)$/, '<h1>\1</h1>')
    x = x.gsub(/^#labels (.*)$/, '')
    x = x.gsub(/----/, '<hr/>') 
    x = x.gsub(/^=== (.*) ===\s*$/, '<h4>\1</h4>')
    x = x.gsub(/^== (.*) ==\s*$/, '<h3>\1</h3>')
    x = x.gsub(/^= (.*) =\s*$/, '<h2>\1</h2>')
    x = x.gsub(/^ \* (.*)$/,   '<ul><li>\1</li></ul>')
    x = x.gsub(/^  \* (.*)$/,  '<ul><li><ul><li>\1</li></ul></li></ul>')
    x = x.gsub(/^   \* (.*)$/, '<ul><li><ul><li><ul><li>\1</li></ul></li></ul></li></ul>')

    # The handling of nested lists is via a simplest-thing-that-kinda-works
    # hack of using CSS to hide nested bullets.
    #
    3.times do
      x = x.gsub(/<ul><li><ul><li>/, '<ul class="innerX"><li><ul><li>')
    end

    x = x.gsub(/<\/li><\/ul>\n<ul><li>/, "<\/li><\/ul>\n<ul class=\"inner0\"><li>")

    return "<div class=\"doc\">\n#{x}\n</div>"
  end

  def load_doc_page(doc_name, page_name)
    valid_name_re = '^[A-Za-z_0-9]+$'

    return nil if doc_name.nil? or page_name.nil?
    return nil unless doc_name.match(valid_name_re)
    return nil unless page_name.match(valid_name_re)

    path = "#{RAILS_ROOT}/db_doc/#{doc_name}/#{page_name}.wiki"
    return nil unless File.exists?(path)

    IO.read(path)
  end
end
