
# Dash for Confluence

*Dash for Confluence is the perfect complement for
users wishing to access a Confluence server on the go.*

### History
'Dash' was a product released in August of 2009 on the App Store.
It was originally concieved as a native browser for Confluence,
optimized for speed and simplicity on the go.  Important to note
that at the time, most Confluence sites were not mobile-optimized.

I was consulting at the time, and had a growing need to access
documentation.  Not being able to do so without pulling out my
laptop drove me to try and find suitable mobile options, of which
there were none.

Some competing products required a server-side component to be
installed by an admin to get a mobile experience.  The goal for
Dash was to rely on both RSS as well as intelligent scraping of
content (similar to what read- later products have done since).
It also provided a read-only 'diff' view of the content history.

The project supported versions up to iOS4, at which time I pulled
from the store due to the time required to keep it up to date, as
well as seeing improvements in mobile-versions of Confluence.  On
a related note, I stopped working with Confluence sites day to day,
making things like support and keeping up to date with new versions
difficult.

The Dash repo was originally in SVN, then later moved to git by the 
time 1.0.3 was released.  The last update added iOS4 support.  The
product was pulled from the AppStore in the spring of 2011.


### Current status

No plans to develop this further but if I were to do so, there are
several things I would do differently now particularly since the iOS
ecosystem has matured quite a bit.  There are better options for networking, caching and parsing content.

*Note:* There were a few framework dependencies which were removed from
this repository.  They can be found elsewhere if necessary, but probably
don't build out of the box anymore.

### Screenshots

Here's a collection of screenshots that originally appeared on the AppStore.

#### Recent Changes

Aside from browsing a space, Dash presented a list of recent changes for a given Space.

![Screenshot](Releases/1.0/screenshots/screenshot%201.png?raw=true)

#### Content

Drilling down to view content.

![Screenshot](Releases/1.0/screenshots/screenshot%2010.png?raw=true)

#### Recent Changes / Differences View

This view displayed differences for a specific change.

![Screenshot](Releases/1.0/screenshots/screenshot%207.png?raw=true)

### Version history

 * 1.0.0 - 2009-Aug (initial release)
 * 1.0.2 - 2009-Sep (performance improvements, enhancement to browsing Spaces &amp; bugfixes)
 * 1.0.3 - 2010-Jul (iOS4 support)

