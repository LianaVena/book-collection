DO $$
BEGIN
   IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'publisher')
   THEN CREATE TYPE publisher AS ENUM();
   END IF;
END $$;

DO $$
BEGIN
   IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'imprint')
   THEN CREATE TYPE imprint AS ENUM();
   END IF;
END $$;

DO $$
BEGIN
   IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'language')
   THEN CREATE TYPE language AS ENUM('English');
   END IF;
END $$;

CREATE TABLE IF NOT EXISTS book (
    id UUID DEFAULT gen_random_uuid () PRIMARY KEY,
    isbn INT UNIQUE NOT NULL,
    title VARCHAR(128),
    subtitle VARCHAR(256),
    publisher publisher,
    imprint imprint,
    first_publication_date DATE,
    publication_date DATE,
    language language,
    pages INT,
    weight INT,
    width INT,
    height INT,
    depth INT
);

DO $$
BEGIN
   IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'gender')
   THEN CREATE TYPE gender AS ENUM('male', 'female', 'other');
   END IF;
END $$;

CREATE TABLE IF NOT EXISTS author (
    id UUID DEFAULT gen_random_uuid () PRIMARY KEY,
    prefix VARCHAR(16),
    first_name VARCHAR(64) NOT NULL,
    middle_name VARCHAR(64),
    last_name VARCHAR(64) NOT NULL,
    suffix VARCHAR(16),
    gender gender
);

DO $$
BEGIN
   IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'author_type')
   THEN CREATE TYPE author_type AS ENUM('author', 'co-author', 'illustrator', 'translator', 'editor');
   END IF;
END $$;

CREATE TABLE IF NOT EXISTS book_author (
    id UUID DEFAULT gen_random_uuid () PRIMARY KEY,
    book_id UUID REFERENCES book(id) NOT NULL,
    author_id UUID REFERENCES author(id) NOT NULL,
    author_type author_type
);

CREATE TABLE IF NOT EXISTS users (
    id UUID DEFAULT gen_random_uuid () PRIMARY KEY
);

DO $$
BEGIN
   IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'ownership')
   THEN CREATE TYPE ownership AS ENUM('own', 'want', 'borrowed', 'owned');
   END IF;
END $$;

DO $$
BEGIN
   IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'status')
   THEN CREATE TYPE status AS ENUM('read', 'reading', 'unread', 'rereading');
   END IF;
END $$;

DO $$
BEGIN
   IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'collection')
   THEN CREATE TYPE collection AS ENUM();
   END IF;
END $$;

DO $$
BEGIN
   IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'series')
   THEN CREATE TYPE series AS ENUM();
   END IF;
END $$;

DO $$
BEGIN
   IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'format')
   THEN CREATE TYPE FORMAT AS ENUM('paperback', 'hardcover', 'flexibound', 'audiobook', 'ebook');
   END IF;
END $$;

DO $$
BEGIN
   IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'country')
   THEN CREATE TYPE country AS ENUM();
   END IF;
END $$;

DO $$
BEGIN
   IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'era')
   THEN CREATE TYPE era AS ENUM();
   END IF;
END $$;

DO $$
BEGIN
   IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'genres')
   THEN CREATE TYPE genres AS ENUM();
   END IF;
END $$;

CREATE TABLE IF NOT EXISTS book_user (
    id UUID DEFAULT gen_random_uuid () PRIMARY KEY,
    book_id UUID REFERENCES book(id) NOT NULL,
    user_id UUID REFERENCES users(id),
    image BYTEA,
    ownership ownership,
    status status,
    collection collection,
    series series,
    format format,
    country country,
    era era,
    genres genres[]
);
