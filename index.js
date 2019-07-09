const express = require('express')
const app = express()
const port = 8000

app.get('/', (req, res) => res.send('Hello World! Automated release successful.'))

app.get('/info', (req, res) => {
		var js = JSON.parse('{"version": "v1.8.0"}');
		res.send(js);
	}
);

app.listen(port, () => console.log(`Example app listening on port ${port}!`))
