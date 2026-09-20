# Publicação da LJCS Solutions

## Supabase

1. Crie um projeto no Supabase.
2. Abra o SQL Editor e execute [`supabase/schema.sql`](./supabase/schema.sql).
3. Copie a URL do projeto e a `service_role` key em **Project Settings > API**. A chave `service_role` deve ficar somente nas variáveis da Vercel.

## Vercel

Para configurar as credenciais em um único terminal interativo, execute no PowerShell:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\setup-integrations.ps1
```

O script solicita Supabase, Resend e Cloudflare, cria `.env.local` (ignorado pelo Git) e, se a CLI da Vercel estiver instalada, envia as variáveis para o ambiente de produção. Nunca cole chaves em arquivos versionados ou no chat.

No terminal, dentro desta pasta:

```powershell
npx vercel login
npx vercel link
npx vercel env add SUPABASE_URL production
npx vercel env add SUPABASE_SERVICE_ROLE_KEY production
npx vercel --prod
```

Para desenvolvimento local, crie `.env.local` a partir de `.env.example` e execute:

```powershell
npx vercel dev
```

O formulário envia os dados para `/api/contact`, que grava na tabela `contact_messages` usando a API REST do Supabase. A chave privada nunca é enviada ao navegador.

## Domínio

Para não conflitar com o JazzMath, a configuração planejada para a empresa é:

- Site LJCS: `www.luancordeirolc.com`
- JazzMath: `app.luancordeirolc.com`

Depois de estar autenticado na Vercel, dentro desta pasta, execute:

```powershell
vercel domains add www.luancordeirolc.com
vercel domains inspect www.luancordeirolc.com
```

No provedor DNS do domínio, crie o registro CNAME informado pelo comando `inspect`. Em configurações DNS externas, normalmente o destino do subdomínio `www` é `cname.vercel-dns.com`; use sempre o valor exibido pela Vercel como fonte final.

## Resend

No painel do Resend, abra **Domains > Add Domain** e adicione `luancordeirolc.com`. O Resend fornecerá registros TXT/MX/CNAME únicos para verificação e DKIM. Crie exatamente esses registros no mesmo provedor DNS, aguarde a propagação e clique em **Verify**. Depois use, por exemplo:

```text
LJCS Solutions <noreply@luancordeirolc.com>
```

Não é seguro inventar os registros do Resend: eles são exclusivos da conta e devem ser copiados do painel após adicionar o domínio.
