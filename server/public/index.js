const endpointTestParagraph = document.getElementById('api-endpoint-test');

// I recommend to try out axios as library, which is easier to use
// than the native fetch API we're using here.
fetch('/api/ping')
    .then(res => {
        if (!res.ok) {
            const err = new Error("Not a 2xx response");
            err.response = res;
            throw err;
        }
        res.text().then(text => {
            endpointTestParagraph.innerText = text;
            console.log(`got data: ${text}`);
        });
    })
    .catch(err => {
        endpointTestParagraph.innerText = err;
        console.error(err);
    });
