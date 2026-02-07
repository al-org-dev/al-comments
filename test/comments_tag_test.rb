require 'minitest/autorun'
require 'liquid'

require_relative '../lib/al_comments'

class AlCommentsTagTest < Minitest::Test
  Site = Struct.new(:config)

  def render_comments(config:, page:)
    template = Liquid::Template.parse('{% al_comments %}')
    template.render({}, registers: { site: Site.new(config), page: page })
  end

  def test_renders_giscus_when_repo_is_present
    output = render_comments(
      config: {
        'max_width' => '930px',
        'enable_darkmode' => true,
        'giscus' => {
          'repo' => 'al-org/al-folio',
          'repo_id' => 'R_kgDO...',
          'category' => 'Comments',
          'category_id' => 'DIC_kwDO...',
          'mapping' => 'title',
          'strict' => 1,
          'reactions_enabled' => 1,
          'emit_metadata' => 0,
          'input_position' => 'bottom',
          'lang' => 'en',
          'light_theme' => 'light',
          'dark_theme' => 'dark'
        }
      },
      page: { 'layout' => 'post', 'giscus_comments' => true }
    )

    assert_includes output, 'https://giscus.app/client.js'
    refute_includes output, 'giscus comments misconfigured'
  end

  def test_renders_giscus_when_repo_uses_symbol_key
    output = render_comments(
      config: {
        'giscus' => {
          repo: 'al-org/al-folio',
          'repo_id' => 'R_kgDO...',
          'category' => 'Comments',
          'category_id' => 'DIC_kwDO...',
          'light_theme' => 'light',
          'dark_theme' => 'dark'
        }
      },
      page: { 'giscus_comments' => true }
    )

    assert_includes output, 'https://giscus.app/client.js'
    refute_includes output, 'giscus comments misconfigured'
  end

  def test_warns_when_required_giscus_ids_are_missing
    output = render_comments(
      config: {
        'giscus' => { 'category' => 'Comments' }
      },
      page: { 'giscus_comments' => true }
    )

    assert_includes output, 'giscus comments misconfigured'
    assert_includes output, 'repo'
    assert_includes output, 'repo_id'
    assert_includes output, 'category_id'
  end

  def test_does_not_fall_back_to_site_repository_for_giscus_repo
    output = render_comments(
      config: {
        'repository' => 'al-org/al-folio',
        'giscus' => {
          'repo_id' => 'R_kgDO...',
          'category' => 'Comments',
          'category_id' => 'DIC_kwDO...'
        }
      },
      page: { 'giscus_comments' => true }
    )

    assert_includes output, 'giscus comments misconfigured'
    refute_includes output, 'https://giscus.app/client.js'
  end

  def test_warns_when_giscus_is_enabled_but_repo_missing
    output = render_comments(
      config: { 'giscus' => {} },
      page: { 'giscus_comments' => true }
    )

    assert_includes output, 'giscus comments misconfigured'
  end

  def test_renders_disqus_with_nested_shortname_and_numeric_flag
    output = render_comments(
      config: { 'disqus' => { 'shortname' => 'al-folio' } },
      page: { 'title' => 'Post', 'id' => '/blog/post', 'disqus_comments' => 1 }
    )

    assert_includes output, 'id="disqus_thread"'
    assert_includes output, "var disqus_shortname  = \"al-folio\";"
    assert_includes output, ".disqus.com/embed.js"
  end
end
