const express = require('express')
const shell = require('shelljs')
const app = express()
const port = 3000
const bodyParser = require('body-parser')
const crypto = require('crypto')

const sigHeaderName = 'x-hub-signature';
app.use(bodyParser.json());

app.get('/', (req, res) => res.send('Hello World!'));

//app.post('/webhooks/github/release', (req, res) => {
//      console.log(req.headers);
//      console.log("Code released");
//      shell.exec('./release.sh');
//      var js = JSON.parse('{"success": true, "message": "Code released"}');
//      res.send(js);
//});

function verifyPostData(req, res, next) {
        var secret = '7Bqm&caSX*qCs4AxZ&JA$WDush#Mc?';
        const payload = JSON.stringify(req.body);
        if (!payload) {
                return next('Request body empty');
        }

        const hmac = crypto.createHmac('sha1', secret)
        const digest = 'sha1=' + hmac.update(payload).digest('hex')
        const checksum = req.headers[sigHeaderName]
        if (!checksum || !digest || checksum !== digest) {
                console.log('Could not verify post data. Request body digest: ', digest, ' did not match signature: ', sigHeaderName, ' and checksum: ', checksum);
                return next(`Request body digest (${digest}) did not match ${sigHeaderName} (${checksum})`);
        }
        console.log('Signature verified');
        return next()
}

app.post('/webhooks/github/release/:env', verifyPostData, function (req, res) {
        var env = req.params.env;
        console.log('Release initiated from Environment: ', env);
        console.log('Headers: ', req.headers);
        var body = req.body;
        if (body.action === 'prereleased') {
                console.log('This is a pre-release from branch: ', body.release.target_commitish);
        }

        var js = JSON.parse('{"success": true, "message": "Dev code released"}');
        res.send(js);
});

app.use((err, req, res, next) => {
        res.status(403).send('Request body was not signed or verification failed');
});

app.listen(port, () => console.log(`Example app listening on port ${port}!`));
                                                                                                                                    