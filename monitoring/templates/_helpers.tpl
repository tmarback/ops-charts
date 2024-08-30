{{- define "group" }}
{{- required "Owning group must be provided" .Values.group }}
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
{{- required "Cloudflare namespace must be provided" .Values.cloudflare.sourceNamespace }}
{{- end }}

{{- define "cloudflare.cert.grafana" }}
{{- printf "%s/%s" ( include "cloudflare.namespace" . ) ( required "Missing grafana secret for cloudflare" .Values.cloudflare.certificates.grafana ) }}
{{- end }}
