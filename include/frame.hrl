-record(frame,
        {cmd :: binary(),
         headers :: map(),
         content_type :: binary(),
         body :: binary()}).

-define(DEFAULT_STOMP_VERSION, 1.2).
-define(KV_RE,"^([a-zA-Z0-9\-_]*):(.*)$").
