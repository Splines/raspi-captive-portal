const p = document.getElementById('api-endpoint-test');

// Try out axios as library, way easier than using the native fetch API
fetch('/api/ping')
    .then(res => {
        if (!res.ok) {
            const err = new Error("Not a 2xx response");
            err.response = res;
            throw err;
        }
        res.text().then(text => {
            p.innerText = text;
            console.log(`got data: ${text}`);
        });
    })
    .catch(err => {
        p.innerText = err;
        console.error(err);
    });
