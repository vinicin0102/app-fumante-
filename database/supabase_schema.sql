-- HABITILITA EXTENSÕES NECESSÁRIAS
create extension if not exists "uuid-ossp";

-- 1. TABELA DE PERFIS (PROFILES)
-- Armazena dados do usuário, progresso, economia e configurações do vício
create table public.profiles (
  id uuid references auth.users not null primary key,
  username text,
  avatar_url text,
  
  -- Sincronização com o Onboarding
  cigarettes_per_day int default 0,
  years_smoking int default 0,
  pack_price decimal(10,2) default 0.0,
  currency text default 'BRL',
  
  -- Progresso
  quit_date timestamp with time zone,
  current_streak_days int default 0,
  xp_total int default 0,
  level int default 1,
  
  -- Metadados
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Habilita RLS (Row Level Security)
alter table public.profiles enable row level security;

-- Políticas de Segurança
create policy "Public profiles are viewable by everyone" 
on public.profiles for select using (true);

create policy "Users can insert their own profile" 
on public.profiles for insert with check (auth.uid() = id);

create policy "Users can update own profile" 
on public.profiles for update using (auth.uid() = id);


-- 2. TABELA DE DIÁRIO (JOURNAL)
-- Registra humor, fissuras e anotações diárias
create table public.journal_entries (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references public.profiles(id) not null,
  
  mood text not null check (mood in ('happy', 'calm', 'neutral', 'anxious', 'sad', 'angry', 'craving')),
  craving_intensity int default 0, -- 0 a 10
  triggers text[], -- Lista de gatilhos (ex: 'coffee', 'stress')
  notes text,
  
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

alter table public.journal_entries enable row level security;

create policy "Users can view own entries" 
on public.journal_entries for select using (auth.uid() = user_id);

create policy "Users can insert own entries" 
on public.journal_entries for insert with check (auth.uid() = user_id);


-- 3. TABELA DE COMUNIDADE (POSTS)
-- Chat global ou feed de mensagens de apoio
create table public.community_posts (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references public.profiles(id) not null,
  
  content text not null,
  likes_count int default 0,
  is_pinned boolean default false,
  
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

alter table public.community_posts enable row level security;

create policy "Posts are viewable by everyone" 
on public.community_posts for select using (true);

create policy "Authenticated users can create posts" 
on public.community_posts for insert with check (auth.role() = 'authenticated');

create policy "Users can delete own posts" 
on public.community_posts for delete using (auth.uid() = user_id);


-- 4. TABELA DE CURTIDAS (LIKES)
create table public.post_likes (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references public.profiles(id) not null,
  post_id uuid references public.community_posts(id) on delete cascade not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  unique(user_id, post_id)
);

alter table public.post_likes enable row level security;

create policy "Likes are viewable by everyone" 
on public.post_likes for select using (true);

create policy "Authenticated users can like posts" 
on public.post_likes for insert with check (auth.role() = 'authenticated');

create policy "Users can remove their like" 
on public.post_likes for delete using (auth.uid() = user_id);


-- 5. TRIGGER PARA CRIAR PERFIL AO CADASTRAR
-- Cria automaticamente uma entrada na tabela profiles quando um user é criado no Auth
create or replace function public.handle_new_user() 
returns trigger as $$
begin
  insert into public.profiles (id, username, created_at, updated_at)
  values (
    new.id, 
    coalesce(new.raw_user_meta_data->>'full_name', 'User ' || substr(new.id::text, 1, 6)),
    now(),
    now()
  );
  return new;
end;
$$ language plpgsql security definer;

-- Remove a trigger se já existir para evitar duplicidade no script
drop trigger if exists on_auth_user_created on auth.users;

-- Cria a trigger
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- views para helpers (opcional)
comment on table public.profiles is 'Perfil estendido do usuário com dados de fumo e gamificação';
