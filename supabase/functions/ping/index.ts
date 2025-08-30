import { serve } from "https://deno.land/std@0.182.0/http/server.ts"
import { corsHeaders } from "../../cors.ts"

serve((req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders })
  }
  return new Response("ok", { headers: corsHeaders })
})
