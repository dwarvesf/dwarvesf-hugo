Hyde-X
======

Enhanced port of the Jekyll "[Hyde](https://github.com/poole/hyde)" theme to the Hugo site generator. Check below for a list of enhancements.

You can find a live site using this theme [here](http://andreimihu.com) and the corresponding source code [here](https://github.com/zyro/andreimihu.com).

* [Installation](#installation)
* [Usage](#usage)
* [Configuration](#configuration)
* [Tips](#tips)
* [Changes and enhancements from the original theme](#changes-and-enhancements-from-the-original-theme)
* [Attribution](#attribution)
* [Questions, ideas, bugs, pull requests?](#questions-ideas-bugs-pull-requests)
* [License](#license)

### Installation

```
$ cd your_site_repo/
$ mkdir themes
$ cd themes
$ git clone https://github.com/zyro/hyde-x
```

See the [official Hugo themes documentation](http://hugo.spf13.com/themes/installing) for more info.

### Usage

This theme expects a relatively standard Hugo blog/personal site layout:
```
.
└── content
    ├── post
    |   ├── post1.md
    |   └── post2.md
    ├── license.md        // this is used in the sidebar footer link
    └── other_page.md
```

Just run `hugo --theme=hyde-x` to generate your site!

### Configuration

An example of what your site's `config.toml` could look like. All theme-specific parameters are under `[params]` and standard Hugo parameters are used where possible.

``` toml
baseurl = "http://example.com/"
title = "Your site title"
languageCode = "en-us"
disqusShortname = "your_disqus_shortname" # Optional, enable Disqus integration
MetaDataFormat = "toml"

[author]
    name = "Your Name"

[permalinks]
    # Optional. Change the permalink format for the 'post' content type.
    # The format shown here is the same one Jekyll/Octopress uses.
    post = "/blog/:year/:month/:day/:title/"

#
# All parameters below here are optional and can be mixed and matched.
#
[params]
    # Used when a given page doesn't set its own.
    defaultDescription = "Your default page description"
    defaultKeywords = "your,default,page,keywords"

    # Changes sidebar background and link/accent colours.
    # See the original Hyde theme for more colour options.
    # This also works: "theme-base-08 layout-reverse", or just "layout-reverse".
	theme = "theme-base-08"

    # Select a syntax highight.
    # Check the static/css/highlight directory for options.
    highlight = "sunburst"

    # Displays under the author name in the sidebar, keep it short.
	tagline = "Your favourite quote or soundbite."

    # Metadata used to drive integrations.
	googleAuthorship = "Your Google+ profile ID"
    googleAnalytics = "Your Google Analytics tracking code"
    gravatarHash = "MD5 hash of your Gravatar email address"

    # Sidebar social links, avoid enabling too many of these if possible.
    # These should be full URLs.
    github = ""
    linkedin = ""
    googleplus = ""
    facebook = ""
    twitter = ""
```

### Tips

* Pages where you specify `menu = "main"` in the front matter will be linked in the sidebar just below the `Blog` link.
* Use the exact permalink format above to maintain old links if migrating from Jekyll/Octopress.
* Although all of the syntax highlight CSS files under the theme's `static/css/highlight` are bundled with the site, only the one you choose will be included in the page and delivered to the browser.
* Change the favicon by providing your own as `static/favicon.png` in your site directory.
* Hugo makes it easy to override theme layout and behaviour, read about it [here](http://hugo.spf13.com/themes/customizing).

### Changes and enhancements from the original theme

* Client-side syntax highlighting through [highlight.js](https://highlightjs.org/), sane fallback if disabled or no JS.
* Disqus integration: comment counts listed under blog entry names in post list, comments displayed at the bottom of each post.
* Gravatar image in sidebar.
* Google Analytics integration.
* Google Authorship metadata.
* Sidebar link layout and footer format changes.
* Blog post list now contains only the post description, not the full contents.
* ...many other small layout tweaks!

### Attribution

Obviously largely a port of the awesome [Hyde](https://github.com/poole/hyde) theme.

### Questions, ideas, bugs, pull requests?

All feedback is welcome! Head over to the [issue tracker](https://github.com/zyro/hyde-x/issues).

### License

Open sourced under the [MIT license](https://github.com/zyro/hyde-x/blob/master/LICENSE).
