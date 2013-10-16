// Generate the table of contents for a page, using the jQuery
// TOC plugin.
//
// Parameters:
//
// insertBefore: selector for jQuery element before which to insert TOC <div>.
//               The first matching element is used.
// heading:      heading, if any

function generateTOC(insertBefore, heading) {
    var container = jQuery("<div id='tocBlock'></div>");
    var div = jQuery("<ul id='toc'></ul>");
    var content = jQuery(insertBefore).first();

    if (heading != undefined && heading != null) {
	container.append('<span class="tocHeading">' + heading + '</span>');
    }

    container.toc({
    	'selectors': 'h1,h2,h3,h4,h5', //elements to use as headings
    	'container': $(".entry-content"), //element to find all selectors in
    	'smoothScrolling': true, //enable or disable smooth scrolling on click
    	'prefix': 'toc', //prefix for anchor tags and class names
    	'highlightOnScroll': true //add class to heading that is currently in focus
    });
    
    // div.tableOfContents(content, {startLevel:2, depth: 5});
    container.append(div);
    container.insertBefore(insertBefore);
}
