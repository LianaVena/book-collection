do $$
begin
   if not exists (select 1 from pg_type where typname = 'publisher')
   then create type if not exists publisher as enum();
   end if;
end $$;

do $$
begin
   if not exists (select 1 from pg_type where typname = 'imprint')
   then create type if not exists imprint as enum();
   end if;
end $$;

do $$
begin
   if not exists (select 1 from pg_type where typname = 'language')
   then create type if not exists language as enum('English');
   end if;
end $$;

create table if not exists book (
    id uuid default gen_random_uuid () primary key,
    isbn int unique not null,
    title varchar(128),
    subtitle varchar(256),
    publisher publisher,
    imprint imprint,
    first_publication_date date,
    publication_date date,
    language language,
    pages int,
    weight int,
    width int,
    height int,
    depth int
);

do $$
begin
   if not exists (select 1 from pg_type where typname = 'gender')
   then create type if not exists gender as enum('male', 'female', 'other');
   end if;
end $$;

create table if not exists author (
    id uuid default gen_random_uuid () primary key,
    prefix varchar(16),
    first_name varchar(64) not null,
    middle_name varchar(64),
    last_name varchar(64) not null,
    suffix varchar(16),
    gender gender
);

do $$
begin
   if not exists (select 1 from pg_type where typname = 'author_type')
   then create type if not exists author_type as enum('author', 'co-author', 'illustrator', 'translator', 'editor');
   end if;
end $$;

create table if not exists book_author (
    id uuid default gen_random_uuid () primary key,
    book_id uuid references book(id) not null,
    author_id uuid references author(id) not null,
    author_type author_type
);

create table if not exists user (
    id uuid default gen_random_uuid () primary key
);

do $$
begin
   if not exists (select 1 from pg_type where typname = 'ownership')
   then create type if not exists ownership as enum('own', 'want', 'borrowed', 'owned');
   end if;
end $$;

do $$
begin
   if not exists (select 1 from pg_type where typname = 'status')
   then create type if not exists status as enum('read', 'reading', 'unread', 'rereading');
   end if;
end $$;

do $$
begin
   if not exists (select 1 from pg_type where typname = 'collection')
   then create type if not exists collection as enum();
   end if;
end $$;

do $$
begin
   if not exists (select 1 from pg_type where typname = 'series')
   then create type if not exists series as enum();
   end if;
end $$;

do $$
begin
   if not exists (select 1 from pg_type where typname = 'format')
   then create type if not exists format as enum('paperback', 'hardcover', 'flexibound', 'audiobook', 'ebook');
   end if;
end $$;

do $$
begin
   if not exists (select 1 from pg_type where typname = 'country')
   then create type if not exists country as enum();
   end if;
end $$;

do $$
begin
   if not exists (select 1 from pg_type where typname = 'era')
   then create type if not exists era as enum();
   end if;
end $$;

create table if not exists book_user (
    id uuid default gen_random_uuid () primary key,
    book_id uuid references book(id) not null,
    user_id uuid references user(id),
    image bytea,
    ownership ownership,
    status status,
    collection collection,
    series series,
    format format,
    country country,
    era era,
    genres genres[]
);
