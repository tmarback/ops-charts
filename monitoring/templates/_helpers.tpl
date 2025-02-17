{{- define "group" }}
{{- required "Owning group must be provided" .Values.group }}
{{- end }}

{{- define "project" }}
{{- required "Owning project must be provided" .Values.project }}
{{- end }}

{{- define "ops.namespace" }}
{{- printf "%s-ops" ( include "group" . ) }}
{{- end }}

{{- define "unison.namespace" }}
{{- printf "%s-unison" ( include "group" . ) }}
{{- end }}

{{- define "unison.url" }}
{{- printf "https://unison.sympho.io/auth/idp/%s" ( include "group" . ) }}
{{- end }}

{{- define "selector.namespace" }}
matchExpressions:
- key: management/group
  operator: In
  values:
  - {{ include "group" . | quote }}
{{- end }}

{{- define "prometheus.hostname.short" }}
{{- printf "prometheus-operated.%s.svc" .Release.Namespace }}
{{- end }}

{{- define "prometheus.hostname.long" }}
{{- printf "prometheus-operated.%s.svc.cluster.local" .Release.Namespace }}
{{- end }}

{{- define "alertmanager.hostname.short" }}
{{- printf "alertmanager-operated.%s.svc" .Release.Namespace }}
{{- end }}

{{- define "alertmanager.hostname.long" }}
{{- printf "alertmanager-operated.%s.svc.cluster.local" .Release.Namespace }}
{{- end }}

{{- define "tempo.hostname.short" }}
{{- printf "tempo-tempo-distributor.%s.svc" .Release.Namespace }}
{{- end }}

{{- define "tempo.hostname.long" }}
{{- printf "tempo-tempo-distributor.%s.svc.cluster.local" .Release.Namespace }}
{{- end }}

{{- define "loki.backend.hostname.short" }}
{{- printf "loki-backend.%s.svc" .Release.Namespace }}
{{- end }}

{{- define "loki.backend.hostname.long" }}
{{- printf "loki-backend.%s.svc.cluster.local" .Release.Namespace }}
{{- end }}

{{- define "loki.read.hostname.short" }}
{{- printf "loki-read.%s.svc" .Release.Namespace }}
{{- end }}

{{- define "loki.read.hostname.long" }}
{{- printf "loki-read.%s.svc.cluster.local" .Release.Namespace }}
{{- end }}

{{- define "loki.write.hostname.short" }}
{{- printf "loki-write.%s.svc" .Release.Namespace }}
{{- end }}

{{- define "loki.write.hostname.long" }}
{{- printf "loki-write.%s.svc.cluster.local" .Release.Namespace }}
{{- end }}

{{- define "grafana.hostname.short" }}
{{- printf "grafana-service.%s.svc" .Release.Namespace }}
{{- end }}

{{- define "grafana.hostname.long" }}
{{- printf "grafana-service.%s.svc.cluster.local" .Release.Namespace }}
{{- end }}

{{- define "grafana.domain" }}
{{- required "Grafana domain must be provided" .Values.grafana.domain }}
{{- end }}

{{- define "grafana.labels" }}
group: {{ include "group" . }}
dashboards: monitoring
{{- end }}

{{- define "grafana.oidc.clientId" }}
{{- required "Missing OIDC client ID" .Values.grafana.oidc.clientID }}
{{- end }}

{{- define "grafana.oidc.clientSecret.name" }}
{{- required "Missing OIDC client secret name" .Values.grafana.oidc.clientSecret.name }}
{{- end }}

{{- define "grafana.oidc.clientSecret.key" }}
{{- required "Missing OIDC client secret key" .Values.grafana.oidc.clientSecret.key }}
{{- end }}

{{- define "grafana.groupMapping" }}
{{- printf "contains(groups[*], '%s') && 'GrafanaAdmin'" ( required "Missing grafana cluster admin group" .Values.grafana.oidc.roleMapping.clusterAdmin ) }} 
{{- with .Values.grafana.oidc.roleMapping.admin }}
{{- printf " || contains(groups[*], '%s') && 'Admin'" . }}
{{- end }}
{{- with .Values.grafana.oidc.roleMapping.editor }}
{{- printf " || contains(groups[*], '%s') && 'Editor'" . }}
{{- end }}
{{- with .Values.grafana.oidc.roleMapping.viewer }}
{{- printf " || contains(groups[*], '%s') && 'Viewer'" . }}
{{- end }}
{{- end }}

{{- define "cloudflare.namespace" }}
{{- default ( include "ops.namespace" . ) .Values.cloudflare.sourceNamespace }}
{{- end }}

{{- define "cloudflare.cert.grafana" }}
{{- printf "%s/%s" ( include "cloudflare.namespace" . ) ( required "Missing grafana secret for cloudflare" .Values.cloudflare.certificates.grafana ) }}
{{- end }}
