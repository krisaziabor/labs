import fetch from 'node-fetch';

const HOST = 'https://yalies.io';
const API_ROOT = '/api/';

interface Criteria {
    query: string;
    filters?: {
        school_code?: string[];
        college?: string[];
        year?: string[];
    };
    page: number;
    page_size: number;
}

interface Person {
    netid: string;
    first_name: string;
    last_name: string;
}

class API {

    async post<T>(endpoint: string, body: unknown): Promise<T> {
        const url = new URL(HOST + API_ROOT + endpoint);
        const response = await fetch(url.toString(), {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${process.env.apiKey}`,
            },
            body: JSON.stringify(body),
        });

        if (!response.ok) {
            const error = await response.text();
            throw new Error(`API request failed: ${response.status} - ${error}`);
        }

        return response.json() as Promise<T>;
    }

    async people(criteria: Criteria): Promise<Person[]> {
        return this.post<Person[]>('people', criteria);
    }
}

async function findPeople(name: string, college: string, year: string): Promise<string | null> {
    try {
        const api = new API();

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
            return null;
        }
    } catch (error) {
        console.error('Error:', (error as Error).message);
        return null;
    }
}

async function findName(netid: string | null): Promise<string | null> {
    if (!netid) return null;

    try {
        const api = new API();

        const people = await api.people({
            query: netid,
            page: 1,
            page_size: 1,
        });

        if (Array.isArray(people) && people.length > 0) {
            for (const person of people) {
                return `${person.first_name} ${person.last_name}`;
            }
        } else {
            console.log('No people found or invalid response:', people);
            return null;
        }
    } catch (error) {
        console.error('Error:', (error as Error).message);
        return null;
    }

    return null;
}

async function verifyStatus(first: string, last: string, college: string, year: string): Promise<boolean> {
    const netID = await findPeople(`${first} ${last}`, college, year);
    const name = await findName(netID);

    if (name === `${first} ${last}`) {
        console.log('We found your details, please proceed');
        return true;
    } else {
        console.log('We could not verify your details, please try again');
        return false;
    }
}

export async function GET(request: Request) {
    const url = new URL(request.url);
    let firstName = url.searchParams.get('firstName') || 'Guest';
    let lastName = url.searchParams.get('lastName') || 'Guest';
    let college = url.searchParams.get('college') || 'Guest';
    let year = url.searchParams.get('year') || 'Guest';

    // Basic sanitization: remove any non-alphanumeric characters
    firstName = firstName.replace(/[^a-zA-Z0-9 ]/g, '');
    lastName = lastName.replace(/[^a-zA-Z0-9 ]/g, '');
    college = college.replace(/[^a-zA-Z0-9 ]/g, '');
    year = year;

    if (!await verifyStatus(firstName, lastName, college, year)) {
        return new Response('We could not verify your details, please try again', { status: 400 });
    } else {
        return new Response(`Hello, ${firstName} ${lastName} from ${college} in ${year}`);
    }
}