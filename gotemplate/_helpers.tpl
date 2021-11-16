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
