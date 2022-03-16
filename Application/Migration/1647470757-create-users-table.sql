CREATE TABLE users (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    email TEXT NOT NULL,
    password_hash TEXT NOT NULL,
    locked_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
    failed_login_attempts INT DEFAULT 0 NOT NULL
);
ALTER TABLE users ADD CONSTRAINT users_email_key UNIQUE(email);
