import { Request, Response } from 'express';

export async function pong(req: Request, res: Response) {
    res.send('pong');
}
