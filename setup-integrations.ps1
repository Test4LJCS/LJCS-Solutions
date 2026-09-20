$ErrorActionPreference = 'Stop'

function Read-SecretValue([string]$Prompt) {
  $secure = Read-Host -Prompt $Prompt -AsSecureString
  $pointer = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
  try {
    return [Runtime.InteropServices.Marshal]::PtrToStringBSTR($pointer)
  } finally {
    [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($pointer)
  }
}

function Read-Required([string]$Prompt) {
  do {
    $value = Read-Host -Prompt $Prompt
    if ([string]::IsNullOrWhiteSpace($value)) { Write-Host 'Este campo é obrigatório.' -ForegroundColor Yellow }
  } while ([string]::IsNullOrWhiteSpace($value))
  return $value.Trim()
}

function Write-EnvValue([string]$Path, [string]$Name, [string]$Value) {
  $escaped = $Value.Replace('\', '\\').Replace('"', '\"')
  Add-Content -Path $Path -Value "$Name=\"$escaped\""
}

Write-Host ''
Write-Host 'LJCS Solutions - configuração de integrações' -ForegroundColor Cyan
Write-Host 'As chaves são solicitadas somente neste terminal e não serão exibidas.'
Write-Host ''

$supabaseUrl = Read-Required 'URL do projeto Supabase (https://....supabase.co)'
$supabaseKey = Read-SecretValue 'Chave service_role do Supabase'
$resendKey = Read-SecretValue 'API Key do Resend (re_xxx)'
$resendFrom = Read-Required 'Remetente verificado do Resend (ex: LJCS <noreply@dominio.com>)'
$cloudflareToken = Read-SecretValue 'Token da API Cloudflare (pode deixar vazio se não usar agora)'

$envPath = Join-Path $PSScriptRoot '.env.local'
if (Test-Path $envPath) {
  $backupPath = "$envPath.backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
  Move-Item $envPath $backupPath
  Write-Host "Configuração anterior preservada em: $backupPath" -ForegroundColor Yellow
}
New-Item -Path $envPath -ItemType File -Force | Out-Null
Write-EnvValue $envPath 'SUPABASE_URL' $supabaseUrl
Write-EnvValue $envPath 'SUPABASE_SERVICE_ROLE_KEY' $supabaseKey
Write-EnvValue $envPath 'RESEND_API_KEY' $resendKey
Write-EnvValue $envPath 'RESEND_FROM' $resendFrom
if (-not [string]::IsNullOrWhiteSpace($cloudflareToken)) {
  Write-EnvValue $envPath 'CLOUDFLARE_API_TOKEN' $cloudflareToken
}
Write-Host "Arquivo local criado: $envPath" -ForegroundColor Green

if (Get-Command vercel.cmd -ErrorAction SilentlyContinue) {
  Write-Host ''
  Write-Host 'Vercel encontrada. Faça login quando solicitado.' -ForegroundColor Cyan
  & vercel.cmd login
  & vercel.cmd link
  foreach ($name in @('SUPABASE_URL', 'SUPABASE_SERVICE_ROLE_KEY', 'RESEND_API_KEY', 'RESEND_FROM')) {
    $value = Get-Content $envPath | Where-Object { $_ -like "$name=*" } | Select-Object -First 1
    $value = $value.Substring($name.Length + 2).Trim('"').Replace('\"', '"').Replace('\\', '\\')
    $value | & vercel.cmd env add $name production
  }
  if (-not [string]::IsNullOrWhiteSpace($cloudflareToken)) {
    $cloudflareToken | & vercel.cmd env add CLOUDFLARE_API_TOKEN production
  }
  Write-Host 'Variáveis enviadas para a Vercel.' -ForegroundColor Green
} else {
  Write-Host 'CLI da Vercel não encontrada. Instale com: npm install -g vercel' -ForegroundColor Yellow
}

Write-Host ''
Write-Host 'Próximos passos manuais:' -ForegroundColor Cyan
Write-Host '1. Execute supabase/schema.sql no SQL Editor do Supabase.'
Write-Host '2. Verifique o domínio remetente no Resend.'
Write-Host '3. Publique com: vercel --prod'
Write-Host '4. Se usar Cloudflare neste projeto, configure o token conforme o serviço utilizado.'
