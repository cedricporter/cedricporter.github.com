# coding: utf-8

require 'rubygems'
require 'hpricot'
require 'fileutils'
require 'time'
require 'ya2yaml'
require 'nokogiri'
require 'cgi'
require 'chinese_pinyin'


# =Overview
# DownmarkIt is a library to convert HTML to markdown, based on Hpricot[http://github.com/hpricot/hpricot/].
#
# =Motivation
# While working on our company's new CMS, I needed to parse HTML back to markdown and surprisngly there wasn't any solution that could fit our enviroment, so I decided to make my own and share it :)
# 
# =Usage
# Make sure you install Hpricot[http://github.com/hpricot/hpricot/] first, then require the library in your application, if you are using the library in a rails application, just place it in your lib folder, then use this method to convert HTML into markdown.
#  markdown = DownmarkIt.to_markdown(html)
# 
# =Features
# This library supports variable header tags, horizontal rulers, emphasis, strong, links, images, blockqoutes, code, unordered lists(nested) and ordered lists(nested)
# 
# =WARNING
# Currently DownmarkIt does not support ul tags inside ol tags or vice versa, maybe in the future i will add it ;)
#
# =License
# This code is licensed under MIT License
#require 'Hpricot'

module DownmarkIt
  # TODO: Add nested unordered lists inside ordered list and vice versa support
  def self.to_markdown(html)
    raw = Hpricot(html.gsub(/(\n|\r|\t)/, ""))

    # headers
    (raw/"/<h\d>/").each do |header|
      if(header.name.match(/^h\d$/))
        header_level = header.name.match(/\d/).to_s.to_i
        header.swap("#{"#" * header_level} #{header.inner_html}\r\n")
      end
    end

    # horizontal rulers
    (raw/"hr").each do |hruler|
      hruler.swap("\r\n---\r\n")
    end

    # emphasis
    (raw/"em").each do |em|
      if(em.name == "em")
        em.swap("_#{em.inner_html}_")
      end
    end

    # strong
    (raw/"strong").each do |strong|
      if(strong.name == "strong")
        strong.swap("**#{strong.inner_html}**")
      end
    end

    # links (anchors)
    (raw/"a").each do |anchor|
      if(anchor.name=="a")
        if(anchor.inner_html != "")
          anchor.swap("[#{anchor.inner_html}](#{anchor['href']}#{" \"#{anchor['title']}\"" if anchor['title']})")
        else
          anchor.swap("<#{anchor['href']}>")
        end
      end
    end

    # image
    (raw/"img").each do |image|
      image.swap("![#{image['alt']}](#{image['src']}#{" \"#{image['title']}\"" if image['title']})")
    end

    # blockqoute
    (raw/"blockqoute").each do |qoute|
      if qoute.name == "blockqoute"
        qoute.swap("> #{nested_qoute(qoute)}")
      end
    end

    # code
    (raw/"code").each do |code|
      if code.name == "code"
        code.swap("``#{code.inner_html}``")
      end
    end

    # unordered list
    (raw/"ul").each do |ul|
      if ul.name == "ul"
        (ul/">li").each do |li|
          if li.name == "li"
            nli = nested_ul(li, 0)
            if (nli.match(/ - /))
              li_inner = (li.inner_text.match(/^\r\n/))?("#{li.inner_text.gsub(/^\r\n/, "")}\r\n"):("- #{li.inner_text}\r\n")
              li.swap("#{li_inner}")
            else
              li.swap("- #{nli}\r\n")
            end
          end
        end
        ul.swap("#{ul.inner_html}")
      end
    end

    # ordered list
    (raw/"ol").each do |ol|
      if ol.name == "ol"
        level = 0
        (ol/">li").each do |li|
          if li.name == "li"
            nli = nested_ol(li, 0)
            if (nli.match(/ \d+\. /))
              li_inner = (li.inner_text.match(/^\r\n/))?("#{li.inner_text.gsub(/^\r\n/, "")}\r\n"):("#{level+=1}. #{li.inner_text}\r\n")
              li.swap("#{li_inner}")
            else
              li.swap("#{level+=1}. #{nli}\r\n")
            end
          end
        end
        ol.swap("#{ol.inner_html}")
      end
    end

    # lines
    (raw /"p").each do |p|
			if p.name == "p"
                          p.swap("\r\n#{p.inner_text}\r\n")
			end
                      end
                      
                      return raw.to_s
                    end
                    
                    private
                    def self.nested_qoute(qoute)
                      nqoute = qoute.at("blockqoute")
                      unless(nqoute.nil?)
			nnqoute = nested_qoute(nqoute)
			"> #{nnqoute}"
                      else
			qoute.inner_html
                      end
                    end
                    
                    def self.nested_ul(li, level)
                      ul = li.at("ul")
                      unless(ul.nil?)
			nested_uli(ul, level + 1)
                      else
			li.inner_html
                      end
                    end
                    
                    def self.nested_uli(li, level)
                      nli = li.at("li")
                      unless(nli.nil?)
			(li/">li").each do |cnli|
                          nnli = nested_ul(cnli, level + 1)
                          if (nnli.match(/ - /))
                            inner_li = (cnli.inner_text.match(/^\r\n/))?(""):(cnli.inner_text)
                            cnli.swap "\r\n#{" " * level}- #{inner_li}" unless inner_li == ""
                          else
                            cnli.swap "\r\n#{" " * level}- #{nnli}"
                          end
			end
			li.inner_html
                      else
			li.inner_html
                      end
                    end

                    def self.nested_ol(li, level)
                      ol = li.at("ol")
                      unless(ol.nil?)
			nested_oli(ol, level + 1)
                      else
			li.inner_html
                      end
                    end

                    def self.nested_oli(li, level)
                      nli = li.at("li")
                      unless(nli.nil?)
			nlevel = 0
			(li/">li").each do |cnli|
                          nnli = nested_ol(cnli, level + 1)
                          if (nnli.match(/ \d+. /))
                            inner_li = (cnli.inner_text.match(/^\r\n/))?(""):(cnli.inner_text)
                            cnli.swap "\r\n#{" " * level}#{nlevel+=1}. #{inner_li}" unless inner_li == ""
                          else
                            cnli.swap "\r\n#{" " * level}#{nlevel+=1}. #{nnli}"
                          end
			end
			li.inner_html
                      else
			li.inner_html
                      end
                    end


                  end


                  LANG_TABLE = {
                    'asm' => 'nasm',
                    'lisp' => 'cl',
                    'bash' => 'bash',
                    'python' => 'python',
                  }

                  def filter_html(html)
                    def remove_node(node)
                      node.children.each do |child|
                        node.add_previous_sibling child
                      end
                      node.remove
                    end

                    def underline_to_u(doc, node)
                      u = doc.create_element 'u'
                      node.children.each do |child|
                        u << child
                      end
                      node.add_previous_sibling u
                      node.remove
                    end

                    def pre_to_codeblock(doc, node)
                      lang = node['class'][/brush: (\w+)/, 1] rescue ''
                      lang = LANG_TABLE[lang] if LANG_TABLE.include? lang
                      u = doc.create_text_node "\n\n``` #{lang}\n#{node.text}\n```\n\n"
                      node.add_previous_sibling u
                      node.remove
                    end

                    html.sub!(/<\!--more--!>/, '')
                    doc = Nokogiri::HTML html
                    doc.css('p').each do |p|
                      remove_node p
                    end

                    doc.css('span').each do |span|
                      remove_node(span) if span['style'] and span['style'][/font-family/]
                      underline_to_u(doc, span) if span['style'] and span['style'][/underline/]
                    end

                    doc.css('pre').each do |pre|
                      pre_to_codeblock(doc, pre) if pre['class'] and pre['class'][/brush/]
                    end
                    CGI.unescapeHTML(doc.css('body').inner_html)
                  end


                  module Jekyll
                    # This importer takes a wordpress.xml file, which can be exported from your
                    # wordpress.com blog (/wp-admin/export.php).
                    module WordpressDotCom
                      def self.process(filename = "wordpress.xml")
                        import_count = Hash.new(0)
                        doc = Hpricot::XML(File.read(filename))

                        (doc/:channel/:item).each do |item|
                          title = item.at(:title).inner_text.strip
                          permalink_title = item.at('wp:post_name').inner_text
                          # Fallback to "prettified" title if post_name is empty (can happen)
                          if permalink_title == ""
                            permalink_title = title.downcase.split.join('-')
                          end

                          date = Time.parse(item.at('wp:post_date').inner_text)
                          status = item.at('wp:status').inner_text

                          if status == "publish"
                            published = true
                          else
                            published = false
                          end

                          type = item.at('wp:post_type').inner_text
                          tags = (item/:category).select{|c| c['domain'] == 'post_tag'}.map{|c| c.inner_text}.reject{|c| c == 'Uncategorized'}.uniq
                          categories = (item/:category).select{|c| c['domain'] == 'category'}.map{|c| c.inner_text}.reject{|c| c == 'Uncategorized'}.uniq
                          excerpt = item.at('excerpt:encoded').inner_text

                          #文章标题
                          if permalink_title != URI.decode(permalink_title)
                            permalink_title = Pinyin.t(URI.decode(permalink_title), '-')
                            permalink_title = permalink_title.gsub(/[，|？|—|：|！|～|。]/, "")
                            puts permalink_title
                          end
                          
                          name = "#{date.strftime('%Y-%m-%d')}-#{permalink_title}.md"
                          header = {
                            'layout'     => type,
                            'title'      => title,
                            'tags'       => tags,
                            'categories' => categories,
                            'status'     => status,
                            'type'       => type,
                            'published'  => published,
                            'excerpt'    => excerpt,
                            'comments'   => true,
                          }.delete_if {|k,v| v.nil? || v == ''}
                          
                          content = item.at('content:encoded').inner_text
                          
                          [
                           /<\s*blockquote.*?>(.*?)<\/\s*?blockquote[^>\w]*?>/m,
                           /\[\s*cc.*?\](.*)\[\/cc\]/m,
                           /<\s*code.*?>(.*?)<\/\s*?code[^>\w]*?>/m,
                           /<\s*pre.*?>(.*?)<\/\s*?pre[^>\w]*?>/m,
                           /<\?php(.*)\?>/m
                          ].each{ |z|
                            if m = z.match(content)
                              content = content.gsub(z, "\n{% codeblock %}\n#{m[1]}\n{% endcodeblock %}\n")
                            end
                          }

                          # convert <code></code> blocks to {% codeblock %}{% endcodeblock %}
                          #content = content.gsub(/<code>(.*?)<\/code>/, '`\1`')
                          #content = content.gsub(/<blockquote>/, '{% codeblock %}')
                          #content = content.gsub(/<\/blockquote>/, '{% endcodeblock %}')

                          # if m1= /<\s*blockquote.*?>(.*?)<\/\s*?blockquote[^>\w]*?>/.match(content)
                          # content.gsub(/<\s*blockquote.*?>(.*?)<\/\s*?blockquote[^>\w]*?>/, "\n{% codeblock %}\n#{m1[1]}\n{% endcodeblock %}\n")
                          # end
                          
                          # convert [cc lang='php'][/cc] blocks to {% codeblock %}{% endcodeblock %}
                          # content = content.gsub(/\[cc lang='([^']*)' \]/, '{% codeblock %}')
                          # content = content.gsub(/\[\/cc\]/, '{% endcodeblock %}')
                          
                          # z = /\[\s*cc.*?\](.*)\[\/cc\]/m
                          # if m= z.match(content)
                          # content.gsub(z, "\n{% codeblock %}\n#{m1[1]}\n{% endcodeblock %}\n")
                          # end
                          
                          # convert <code></code> blocks to {% codeblock %}{% endcodeblock %}
                          #content = content.gsub(/<code>/, '{% codeblock %}')
                          #content = content.gsub(/<code .*?>/, '{% codeblock %}')
                          #content = content.gsub(/<\/code>/, '{% endcodeblock %}')
                          
                          # if m1= /<\s*code.*?>(.*?)<\/\s*?code[^>\w]*?>/.match(content)
                          # content.gsub(/<\s*code.*?>(.*?)<\/\s*?code[^>\w]*?>/, "\n{% codeblock %}\n#{m1[1]}\n{% endcodeblock %}\n")
                          # end

                          # convert <pre></pre> blocks to {% codeblock %}{% encodeblock %}
                          #content = content.gsub(/<pre lang="([^"]*)">(.*?)<\/pre>/m, '`\1`')
                          #content = content.gsub(/<pre>/, '{% codeblock %}')
                          #content = content.gsub(/<pre lang="([^"]*)">/, '{% codeblock %}')
                          #content = content.gsub(/<\/pre>/m, '{% endcodeblock %}')
                          
                          # if m1= /<\s*pre.*?>(.*?)<\/\s*?pre[^>\w]*?>/.match(content)
                          # content.gsub(/<\s*code.*?>(.*?)<\/\s*?code[^>\w]*?>/, "\n{% codeblock %}\n#{m1[1]}\n{% endcodeblock %}\n")
                          # end
                          
                          # convert images to OctopressBlog
                          content = content.gsub(/http:\/\/zh-w\.info\/wp-content\/uploads/, '/images/uploads')
                          content = content.gsub(/\/wp-content\/uploads/, '/images/uploads')
                          

                          FileUtils.mkdir_p "_#{type}s"
                          File.open("_#{type}s/#{name}", "w:utf-8") do |f|
                            f.puts header.ya2yaml
                            f.puts '---'
                            f.puts filter_html(content)
                          end

                          import_count[type] += 1
                        end

                        import_count.each do |key, value|
                          puts "Imported #{value} #{key}s"
                        end
                      end
                    end
                  end

                  Jekyll::WordpressDotCom.process(ARGV[0])
