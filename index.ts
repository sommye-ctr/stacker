// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

// Setup type definitions for built-in Supabase Runtime APIs
import "jsr:@supabase/functions-js/edge-runtime.d.ts"
import { createClient } from 'npm:@supabase/supabase-js@2'

console.log("Hello from Functions!")

Deno.serve(async (req) => {
  const supabaseClient = createClient(
    Deno.env.get('SUPABASE_URL') ?? '',
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? '',
    { global: { headers: { Authorization: `Bearer ${Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")}` } } }
  )

  const url = new URL(req.url);
  const params = new URLSearchParams(url.search);

  const today = new Date();
  today.setHours(0, 0, 0, 0);

  const {data: rows, error} = await supabaseClient.from("booking").select('*')
                          .eq('stack_id', params.get('stackId'))
                          .gte('time_creation', today.toISOString())
                          .lt('time_creation', new Date(today.getTime() + 24 * 60 * 60 * 1000).toISOString())
                          .order('token', {ascending : false})
                          .limit(1);
  if (error) {
    return new Response(JSON.stringify({ error: error.message }), { status: 400 });
  }

  const {data: stack, error: err} = await supabaseClient.from("stacks")
                              .select('*')
                              .eq('id', params.get('stackId'));
  if (err) {
    return new Response(JSON.stringify({ error: err.message }), { status: 400 });
  }

  const {data: stackDetails,error: e} = await supabaseClient.from("stack_details").select('*')
                            .eq('stack_id', params.get('stackId'));
  if (e) {
    return new Response(JSON.stringify({ error: e.message }), { status: 400 });
  }
                            
  if (stack && stack!.at(0).status == 'Closed'){
    return new Response(JSON.stringify({ message: 'The stack is not open yet.' }), { status: 409 });
  }

  let nextToken, timeStamp;
  if (rows && rows.length > 0) {
    console.log("if");
    if (stackDetails && rows!.at(0).token >= stackDetails!.at(0).max_token) {
      return new Response(JSON.stringify({ message: 'The stack is not accepting anymore bookings for now.' }), { status: 409 });
    }

    const minToAdd = stackDetails!.at(0).avg_duration + stackDetails!.at(0).break_duration;

    nextToken = rows!.at(0).token + 1;
    const temp = timeStringToDate(rows!.at(0).time_arrival);
    timeStamp = new Date(temp.getTime() + minToAdd * 60000); // 60000 ms = 1 minute
  } else {
    const currentTimeInSeconds = getCurrentTimeInSeconds();
    const postgresTimeInSeconds = timeStringToSeconds(stack!.at(0).open_time);

    nextToken = 1;
    if (currentTimeInSeconds <= postgresTimeInSeconds) {
      timeStamp = timeStringToDate(stack!.at(0).open_time);
    } else {
      timeStamp = new Date();
    }
  }
  
  return new Response(
    JSON.stringify({
      'token' : nextToken,
      'time_arrival' : timeStamp,
      'user_id' : params.get('userId'),
      'stack_id' : params.get('stackId'),
      'status' : 'Active', 
  }), 
    { headers: { 'Content-Type': 'application/json' }, }
  );
})

function timeStringToSeconds(timeString: string): number {
  const [hours, minutes, seconds] = timeString.split(':').map(Number);
  return hours * 3600 + minutes * 60 + (seconds || 0);
}

function timeStringToDate(timeString: string): Date {
  const [hours, minutes, seconds] = timeString.split(':').map(Number);
  const current = new Date();

  return new Date(current.getFullYear(), current.getMonth(), current.getDay(), hours, minutes, seconds, 0);
}

function getCurrentTimeInSeconds(): number {
  const now = new Date();
  return now.getHours() * 3600 + now.getMinutes() * 60 + now.getSeconds();
}


/* To invoke locally:

  1. Run `supabase start` (see: https://supabase.com/docs/reference/cli/supabase-start)
  2. Make an HTTP request:

  curl -i --location --request POST 'http://127.0.0.1:54321/functions/v1/create-booking' \
    --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0' \
    --header 'Content-Type: application/json' \
    --data '{"name":"Functions"}'

*/
