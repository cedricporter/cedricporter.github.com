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
    var content = jQuery(insertBefore).first();

    container.toc({
    	'selectors': 'h1,h2,h3,h4,h5',
    	'container': $(".entry-content"),
    	'smoothScrolling': true,
    	'prefix': 'toc',
    	'highlightOnScroll': true 
    });

    container.find("a").addClass("disc-like");
    
    // div.tableOfContents(content, {startLevel:2, depth: 5});
    container.insertBefore(insertBefore);

    if (heading != undefined && heading != null) {
	container.prepend('<span class="tocHeading">' + heading + '</span>');
    }

}

