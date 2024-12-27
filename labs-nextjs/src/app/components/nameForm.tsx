import React, { useState } from 'react';

const NameForm = () => {
    const [firstName, setFirstName] = useState('');
    const [lastName, setLastName] = useState('');
    const [college, setCollege] = useState('');
    const [year, setYear] = useState('');
    const [greeting, setGreeting] = useState('');

    const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
        e.preventDefault();
        const response = await fetch(`/api?firstName=${firstName}&lastName=${lastName}&college=${college}&year=${year}`);
        const text = await response.text();
        setGreeting(text);
    };

    return (
        <div>
            <form onSubmit={handleSubmit}>
                <label>
                    First Name:
                    <input
                        type="text"
                        value={firstName}
                        onChange={(e) => setFirstName(e.target.value)}
                        required
                    />
                </label>
                <br />
                <label>
                    Last Name:
                    <input
                        type="text"
                        value={lastName}
                        onChange={(e) => setLastName(e.target.value)}
                        required
                    />
                </label>
                <br />
                <label>
                    College:
                    <input
                        type="text"
                        value={college}
                        onChange={(e) => setCollege(e.target.value)}
                        required
                    />
                </label>
                <br />
                <label>
                    Year:
                    <input
                        type="text"
                        value={year}
                        onChange={(e) => setYear(e.target.value)}
                        required
                    />
                </label>
                <br />
                <button type="submit">Submit</button>
            </form>
            {greeting && <p>{greeting}</p>}
        </div>
    );
};

export default NameForm;
