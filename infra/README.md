# Azure deployment

1. `az login`, then export `OPENAI_API_KEY`, `NEXT_PUBLIC_SUPABASE_URL`, `NEXT_PUBLIC_SUPABASE_ANON_KEY`.
2. `APP=<unique-name> ./infra/provision-azure.sh`
3. In GitHub repo settings add:
   - Secret `AZURE_WEBAPP_PUBLISH_PROFILE` (XML printed by the script)
   - Secrets `NEXT_PUBLIC_SUPABASE_URL`, `NEXT_PUBLIC_SUPABASE_ANON_KEY`
   - Variable `AZURE_WEBAPP_NAME` (same as `APP`)
   - Optional variable `NEXT_PUBLIC_AUTH_GITHUB`
4. Push to `main`, or run the workflow manually.
5. In Supabase auth settings, add `https://<APP>.azurewebsites.net` as a redirect URL.
