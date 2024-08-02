// Collection of bookmarklets

// Stop dynamic behavior on a page
javascript:(
    function(){
        var id = window.setInterval(function() {}, 0); 
        while(id--){ 
            window.clearInterval(id);
        }
    }
)();

// Set github dates to non-relative
// Shamelessly stolen from fngjdflmdflg on HN
// Discussion: https://news.ycombinator.com/item?id=41037011
javascript:(
    function () {
        document.querySelectorAll("relative-time").forEach(
            (el)=>el.replaceWith(document.createElement("span").innerHTML = el.title)
        ) 
    }
)();

// TODOs
// Wayback/Archive
// https://news.ycombinator.com/item?id=39980326
// https://news.ycombinator.com/item?id=40076943
// 
// HN favorite bookmarklets
// https://news.ycombinator.com/item?id=39745425
