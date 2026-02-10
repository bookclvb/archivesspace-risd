# risd_branding plugin README

Created by EC February 2026
For ArchivesSpace version 4.1.1

**Note:** Atlas does not write or support or plugin customizations. We must maintain this ourselves. Worth checking every time we upgrade.

"A general rule is: to override behavior, rather then extend it, match the path to the file that contains the behavior to be overridden.” More plugins documentation [here](https://docs.archivesspace.org/customization/plugins/).

## plugin structure

Because plugins are meant to override behavior, they mirror the structure of the matching directory in ArchivesSpace. For now, I am focusing on the public user interface, which is the “public” folder. We could potentially add a  “frontend” folder next to alter the staff interface. 

### risd_branding/public

CSS modifications are stored in `risd_branding/public/assets/risd_pui.css`
Can make JS modifications then same way.

Various files then must be created to point to this:
- `risd_branding/public/views/layout_head.html.erb` **Currently just pointing with this one as a test.**
- `risd_branding/public/views/welcome/show.html.erb`
- `risd_branding/public/views/site/_branding.html.erb` (though I’m confused because the docs write this out "plugins/local/frontend/views/site/\_branding.html.erb")
- `risd_branding/public/views/shared/_footer.html.erb`
- `risd_branding/public/views/shared/_header.html.erb`


Not bothering to change the favicon right now. 



