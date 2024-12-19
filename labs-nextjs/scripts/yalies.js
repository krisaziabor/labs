import dotenv from 'dotenv';
import fetch from 'node-fetch';

dotenv.config({ path: './private.env' });

const apiKey = process.env.YALIES_API_KEY;

const HOST = 'https://yalies.io';
const API_ROOT = '/api/';

class API {
    constructor(key) {
        this.key = key;
    }

    async post(endpoint, body) {
        const url = new URL(HOST + API_ROOT + endpoint);
        const response = await fetch(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${this.key}`,
            },
            body: JSON.stringify(body),
        });

        if (!response.ok) {
            const error = await response.text();
            throw new Error(`API request failed: ${response.status} - ${error}`);
        }

        return response.json();
    }

    people(criteria) {
        return this.post('people', criteria);
    }
}

async function findPeople(name, college, year) {
    try {
        const api = new API(apiKey);

        const people = await api.people({
            query: name,
            filters: {
                school_code: ['YC'],
                college: [college],
                year: [year],
            },
            page: 1,
            page_size: 1,
        });

        if (Array.isArray(people) && people.length > 0) {
            console.log(people[0].netid);
            return people[0].netid;

        } else {
            console.log('No people found or invalid response:', people);
        }
    } catch (error) {
        console.error('Error:', error.message);
    }
}



// Issue with the Yalies API is the lack of precision, therefore I have to use the netid to match the first names

async function findName(netid) {
    try {
        const api = new API(apiKey);

        const people = await api.people({
            query: netid,
            page: 1,
            page_size: 1,
        });

        if (Array.isArray(people) && people.length > 0) {
            for (const person of people) {
                // console.log(person.first_name + ' ' + person.last_name);
                return person.first_name + ' ' + person.last_name;
            }
        } else {
            console.log('No people found or invalid response:', people);
            return 0;
        }
    } catch (error) {
        console.error('Error:', error.message);
        return 0;
    }
}

(async () => {
    const first_name = 'Kris';
    const surname = 'Aziabor';
    const full_name = `${first_name} ${surname}`;
    const netID = await findPeople(full_name, 'Timothy Dwight', '2026');
    const name = await findName(netID);
    if (name === full_name){
        console.log('We found your details, please proceed');
    }
    else{
        console.log('We could not verify your details, please try again');
    }
})();

