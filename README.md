# LJCS Solutions

Site institucional da LJCS Solutions, com foco em tecnologia, desenvolvimento web e soluções digitais sob medida.

## Visão geral

- Landing page responsiva em HTML/CSS/JS
- Estrutura voltada para apresentação de serviços, diferenciais e contatos
- Formulário de contato integrado ao backend do Vercel
- Preparado para deploy em Vercel com Supabase

## Estrutura principal

- `index.html` — estrutura da landing page
- `styles.css` — estilos e responsividade
- `script.js` — menu mobile e envio do formulário
- `api/contact.js` — endpoint do formulário
- `supabase/schema.sql` — schema de mensagens de contato
- `DEPLOY.md` — instruções de publicação e integrações

## Configuração local

1. Crie um arquivo `.env.local` com base em `.env.example`
2. Instale as dependências do projeto com a CLI da Vercel, se necessário
3. Execute:

```bash
npx vercel dev
```

## Publicação

Este projeto está configurado para ser publicado na Vercel e integrado ao Supabase.
