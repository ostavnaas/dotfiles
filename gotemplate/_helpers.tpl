{{- define "foo.hello_world"}}
Hello world
{{- end }}

{{/* check if boolean_true is true */}}
{{- define "foo.is_true" }}
{{- if . }}
True
{{- else }}
False
{{- end }}
{{- end }}

{{- define "foo.has_key" }}
{{- if has .ds .key }}
.key is in array
{{- end }}
{{- end }}


{{- define "list_to_comma" }}
{{- $comma_list := ""}}
{{- range .}}
{{- if eq $comma_list "" }}
{{- $comma_list = printf "%s" . }}
{{- else }}
{{- $comma_list = printf "%s,%s" $comma_list . }}
{{- end }}
{{- end }}
{{ $comma_list }}
{{- end }}

{{- define "get_keys" }}
{{- $foo := dict }}
{{- $comma_list := "" }}
{{- range $key, $value := . }}
{{ $k := split $key "_" }}
{{ index $k 0 }}
{{- $comma_list = printf "%s,%s" $key $comma_list }}
{{ $foo = dict (index $k 0 ) $comma_list }}
{{- end }}
{{ index $foo "dict" }}
{{- end }}


{{- define "join_array" }}
{{ join .my_array "," }}
{{  }}
{{- end }}
