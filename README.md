# Clipped Asset Roles

Allows you to specify 'asset roles', so you can add meaning to a relation between a page and an asset. For example a page can have 5 images attached, and 4 of those have a role of 'portfolio image'. With radius you can then render just those 4 images into a gallery.

## Requirements

[Radiant Clipped extension](https://github.com/radiant/radiant-clipped-extension/) is required. This was built against clipped 1.0.16, but I'm quite sure older versions should work as well. I required ~> 1.0.10 but that was actually guesswork.. do let me know if you find clipped versions where this breaks.

## Configuration

Set the asset roles for your site in Radiant::Config["clipped\_asset\_roles.roles"] with format "role1:one,role2:many". The default config defines 'page icon' and 'portfolio' roles that you will probably want to replace with your own.

You can customize the roles available to a certain page by adding a page field 'asset\_roles' or 'children\_asset\_roles' using the same role:association_type format. 
The latter will overwrite the roles for all direct children of the page on which it is defined.

Finally, you can define 'extra\_asset\_roles' or 'extra\_children\_asset\_roles' which will add the roles to the ones defined in Radiant::Config.
Configuration through a parent page will be overwritten by configuration on the child page if applicable.

## Usage

An asset role belongs\_to a page\_attachment, not an asset. On the page edit view, in the 'image bucket', you can select roles for attached assets.

Then, you could use this radius code to select the page_icon e.g. for the current page:

    <r:asset:image roles="page_icon" />

or do things like:

    <ul class="gallery"><r:assets:each roles="portfolio|cover" order="desc" by="position">
      <li><r:asset:image size="thumbnail"/></li>
    </ul></r:assets:each>

So, r:assets:each, r:asset, r:if\_assets and r:unless_assets all take a 'roles' attribute now.
If more than one role is provided in the context of r:asset, the first matched asset will be returned.
