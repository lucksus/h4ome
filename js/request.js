
.pragma library

function get(url, callback) {
    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = (function(myxhr) {
        return function() {
            if(myxhr.readyState === 4) callback(myxhr.responseText)
        }
    })(xhr);
    xhr.open('GET', url, true);
    xhr.send('');
}
