import { verifyStatus } from '../../../scripts/yalies.js';

export default async function handler(req, res) {
    if (req.method === 'POST') {
        const { firstName, lastName, college, year } = req.body;

        if (!firstName || !lastName || !college || !year) {
            return res.status(400).json({ error: 'All fields are required.' });
        }

        try {
            const isValid = await verifyStatus(firstName, lastName, college, year);

            if (isValid) {
                return res.status(200).json({ success: true, message: 'Details verified successfully.' });
            } else {
                return res.status(400).json({ success: false, message: 'Verification failed. Please try again.' });
            }
        } catch (error) {
            console.error(error);
            return res.status(500).json({ error: 'Internal server error.' });
        }
    } else {
        res.setHeader('Allow', ['POST']);
        return res.status(405).json({ error: `Method ${req.method} not allowed.` });
    }
}