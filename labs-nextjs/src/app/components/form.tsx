import { useState } from 'react';

export default function VerifyForm() {
    const [formData, setFormData] = useState({
        firstName: '',
        lastName: '',
        college: '',
        year: '',
    });

    const [status, setStatus] = useState<{ success: boolean; message: string } | null>(null);

    const handleChange = (e) => {
        const { name, value } = e.target;
        setFormData((prev) => ({ ...prev, [name]: value }));
    };

    const handleSubmit = async (e) => {
        e.preventDefault();

        try {
            const response = await fetch('../api/verify-status.js', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(formData),
            });

            const result = await response.json();

            if (response.ok) {
                setStatus({ success: true, message: result.message });
            } else {
                setStatus({ success: false, message: result.message || result.error });
            }
        } catch {
            setStatus({ success: false, message: 'Something went wrong. Please try again.' });
        }
    };

    return (
        <div>
            <form onSubmit={handleSubmit}>
                <div>
                    <label>First Name:</label>
                    <input
                        type="text"
                        name="firstName"
                        value={formData.firstName}
                        onChange={handleChange}
                        required
                    />
                </div>
                <div>
                    <label>Last Name:</label>
                    <input
                        type="text"
                        name="lastName"
                        value={formData.lastName}
                        onChange={handleChange}
                        required
                    />
                </div>
                <div>
                    <label>Residential College:</label>
                    <input
                        type="text"
                        name="college"
                        value={formData.college}
                        onChange={handleChange}
                        required
                    />
                </div>
                <div>
                    <label>Year:</label>
                    <input
                        type="text"
                        name="year"
                        value={formData.year}
                        onChange={handleChange}
                        required
                    />
                </div>
                <button type="submit">Verify</button>
            </form>
            {status && (
                <div style={{ color: status.success ? 'green' : 'red' }}>
                    {status.message}
                </div>
            )}
        </div>
    );
}