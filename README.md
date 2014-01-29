GSS website
===========

This repository contains the [Jekyll](http://jekyllrb.com/) sources for the GSS website. Changes pushed to this repository will automatically appear on the website.

## Local development

Simply [install Jekyll](http://jekyllrb.com/docs/installation/) and run:

```shell
$ jekyll serve --watch
```

This will start website generation and serve the site at <http://localhost:4000>. Any file changes will cause a regeneration, and will be available on the site after a browser reload.

## Content management

Primary site contents are handled as [Jekyll posts](http://jekyllrb.com/docs/posts/) that can be either Markdown or HTML. The posts are stored in separate `_posts` folders under various folders of the site content categories:

* `home`: sections of the main page
* `guide`: user guide articles
* `example`: example articles

### Content ordering

As usual with Jekyll, the contents listings for each section will be ordered by post date, newest first. Set a correct date for each post (in the file name or metadata) to get the arranged in the way you like.

### Section IDs

To provide helpful styling hooks, the `section` tags on content listings will have IDs based on the URL of the post. So, for example the file `home/_posts/YYYY-MM-DD-hello-world.md` would generate the following section:

```html
<section id="home_hello_world">
  <h1>Section title</h1>
  Section contents
</section>
```
