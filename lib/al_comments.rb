require 'jekyll'
require 'json'

module AlComments
  class CommentsTag < Liquid::Tag
    def render(context)
      site = context.registers[:site]
      return '' unless site

      page = context.registers[:page] || context['page'] || {}
      output = []

      if site.config['disqus_shortname'] && truthy?(page['disqus_comments'])
        output << disqus_html(site, page)
      end

      if truthy?(page['giscus_comments'])
        output << giscus_html(site, page)
      end

      output.join("\n")
    end

    private

    def truthy?(value)
      value == true || value.to_s == 'true'
    end

    def post_layout?(page)
      page['layout'].to_s == 'post'
    end

    def disqus_html(site, page)
      <<~HTML
        <div id="disqus_thread" style="max-width: #{site.config['max_width']}; margin: 0 auto;">
          <script type="text/javascript">
            var disqus_shortname  = #{site.config['disqus_shortname'].to_json};
            var disqus_identifier = #{page['id'].to_s.to_json};
            var disqus_title      = #{page['title'].to_s.to_json};
            (function() {
              var dsq = document.createElement('script');
              dsq.type = 'text/javascript';
              dsq.async = true;
              dsq.src = '//' + disqus_shortname + '.disqus.com/embed.js';
              (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
            })();
          </script>
          <noscript>
            Please enable JavaScript to view the
            <a href="https://disqus.com/?ref_noscript">comments powered by Disqus.</a>
          </noscript>
        </div>
      HTML
    end

    def giscus_html(site, page)
      giscus = site.config['giscus'] || {}
      style = post_layout?(page) ? " style=\"max-width: #{site.config['max_width']}; margin: 0 auto;\"" : ''
      spacer = post_layout?(page) ? "\n  <br>" : ''

      if giscus['repo'].to_s.strip.empty?
        warning = <<~MARKDOWN
          > ##### giscus comments misconfigured
          > Please follow instructions at [http://giscus.app](http://giscus.app) and update your giscus configuration.
          {: .block-danger }
        MARKDOWN
        return %(<div id="giscus_thread"#{style}>#{spacer}\n#{Jekyll::Converters::Markdown.new(site.config).convert(warning)}</div>)
      end

      <<~HTML
        <div id="giscus_thread"#{style}>#{spacer}
          <script>
            (function setupGiscus() {
              function determineGiscusTheme() {
                #{theme_detection(site)}
              }

              var giscusTheme = determineGiscusTheme();
              var attrs = {
                src: "https://giscus.app/client.js",
                "data-repo": #{giscus['repo'].to_s.to_json},
                "data-repo-id": #{giscus['repo_id'].to_s.to_json},
                "data-category": #{giscus['category'].to_s.to_json},
                "data-category-id": #{giscus['category_id'].to_s.to_json},
                "data-mapping": #{giscus['mapping'].to_s.to_json},
                "data-strict": #{giscus['strict'].to_s.to_json},
                "data-reactions-enabled": #{giscus['reactions_enabled'].to_s.to_json},
                "data-emit-metadata": #{giscus['emit_metadata'].to_s.to_json},
                "data-input-position": #{giscus['input_position'].to_s.to_json},
                "data-theme": giscusTheme,
                "data-lang": #{giscus['lang'].to_s.to_json},
                crossorigin: "anonymous",
                async: true
              };

              var giscusScript = document.createElement("script");
              Object.entries(attrs).forEach(function(entry) { giscusScript.setAttribute(entry[0], entry[1]); });
              var host = document.getElementById("giscus_thread");
              if (host) host.appendChild(giscusScript);
            })();
          </script>
          <noscript>
            Please enable JavaScript to view the
            <a href="http://giscus.app/?ref_noscript">comments powered by giscus.</a>
          </noscript>
        </div>
      HTML
    end

    def theme_detection(site)
      if site.config['enable_darkmode']
        <<~JS
          var theme = localStorage.getItem("theme") || document.documentElement.getAttribute("data-theme") || "system";
          if (theme === "dark") return #{site.config.dig('giscus', 'dark_theme').to_s.to_json};
          if (theme === "light") return #{site.config.dig('giscus', 'light_theme').to_s.to_json};
          var prefersDark = window.matchMedia("(prefers-color-scheme: dark)").matches;
          return prefersDark ? #{site.config.dig('giscus', 'dark_theme').to_s.to_json} : #{site.config.dig('giscus', 'light_theme').to_s.to_json};
        JS
      else
        %(return #{site.config.dig('giscus', 'light_theme').to_s.to_json};)
      end
    end
  end
end

Liquid::Template.register_tag('al_comments', AlComments::CommentsTag)
