{{/*
Expand the name of the chart.
*/}}
{{- define "prysm.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "prysm.fullname" -}}
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

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "prysm.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "prysm.labels" -}}
helm.sh/chart: {{ include "prysm.chart" . }}
{{ include "prysm.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "prysm.selectorLabels" -}}
app.kubernetes.io/name: {{ include "prysm.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "prysm.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "prysm.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the cluster role.
It needs to be namespace prefixed to avoid naming conflicts when using the same deployment name across namespaces.
*/}}
{{- define "prysm.clusterRoleName" -}}
{{ .Release.Namespace }}-{{ include "prysm.fullname" . }}
{{- end }}

{{- define "prysm.p2pPort" -}}
{{- if and (.Values.p2pNodePort.enabled) (gt (int .Values.replicas)  1) }}
{{- print .Values.p2pNodePort.port }}
{{- else }}
{{- print .Values.p2pPort }}
{{- end }}
{{- end -}}

{{- define "prysm.replicas" -}}
{{- if and (.Values.p2pNodePort.enabled) (gt (int .Values.replicas)  1) }}
{{- print 1 }}
{{ else }}
{{- print .Values.replicas }}
{{- end }}
{{- end -}}
