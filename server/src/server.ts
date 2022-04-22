import express, { NextFunction, Request, Response } from 'express';
import path from 'path';
import { pong } from './pong';


////////////////////////////// Setup ///////////////////////////////////////////

const HOST_NAME = 'splines.portal';
const FRONTEND_FOLDER = path.join(__dirname, '../', 'public');

const app = express();

// Redirect every request to our application
// https://raspberrypi.stackexchange.com/a/100118
// [You need a self-signed certificate if you really want 
// an https connection. In my experience, this is just a pain to do
// and probably overkill for a project where you have your own WiFi network
// without Internet access anyway.]
app.use((req: Request, res: Response, next: NextFunction) => {
    if (req.hostname != HOST_NAME) {
        return res.redirect(`http://${HOST_NAME}`);
    }
    next();
});

// Call this AFTER app.use where we do the redirects
app.use(express.static(FRONTEND_FOLDER));


/////////////////////////////// Endpoints //////////////////////////////////////

// Serve frontend
app.get('/', (req, res, next) => {
    res.sendFile(path.join(FRONTEND_FOLDER, 'index.html'));
});

app.get('/api/ping', pong);


///////////////////////////// Server listening /////////////////////////////////

// Listen for requests
// If you change the port here, you have to adjust the ip tables as well
// see file: access-point/setup-access-point.sh
const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Node version: ${process.version}`);
    console.log(`⚡ Raspberry Pi Server listening on port ${PORT}`);
});
