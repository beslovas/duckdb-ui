{{- define "duckdb-ui.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "duckdb-ui.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "duckdb-ui.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "duckdb-ui.labels" -}}
helm.sh/chart: {{ include "duckdb-ui.chart" . }}
{{ include "duckdb-ui.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "duckdb-ui.selectorLabels" -}}
app.kubernetes.io/name: {{ include "duckdb-ui.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "duckdb-ui.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "duckdb-ui.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "duckdb-ui.configMapName" -}}
{{- printf "%s-config" (include "duckdb-ui.fullname" .) }}
{{- end }}

{{- define "duckdb-ui.pvcName" -}}
{{- printf "%s" (include "duckdb-ui.fullname" .) }}
{{- end }}
