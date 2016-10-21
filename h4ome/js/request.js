
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

function post(url, params, callback, error) {
    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = (function(myxhr) {
        return function() {
            if(myxhr.readyState === 4)
                if(myxhr.status === 200)
                    callback(myxhr.responseText)
                else
                    error(myxhr.responseText, myxhr.status)
        }
    })(xhr);
    xhr.open('POST', url, true);
    xhr.setRequestHeader('Content-type', 'application/json');
    xhr.setRequestHeader('Content-length', params.length);
    xhr.setRequestHeader('Connection', 'close');
    xhr.send(params);
}
