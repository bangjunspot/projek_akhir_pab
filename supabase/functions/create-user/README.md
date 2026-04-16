# Deploy Edge Function: create-user

## Prasyarat
- Supabase CLI terinstall
- Sudah login: `supabase login`
- Project sudah di-link: `supabase link --project-ref <your-project-ref>`

## Cara deploy
```bash
supabase functions deploy create-user
```

## Environment variable
Edge Function ini memakai variabel runtime Supabase:
- `SUPABASE_URL`
- `SUPABASE_SERVICE_ROLE_KEY`

Tidak perlu set `.env` tambahan.

## Test via curl (opsional)
```bash
curl -X POST https://<project-ref>.supabase.co/functions/v1/create-user \
  -H "Authorization: Bearer <user-jwt-token>" \
  -H "Content-Type: application/json" \
  -d '{"email":"kasir2@bangjun.id","password":"password123","role":"kasir"}'
```
