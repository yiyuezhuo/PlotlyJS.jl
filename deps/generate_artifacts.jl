# This script gets run once, on a developer's machine, to generate artifacts
using Pkg.Artifacts

artifacts_toml = joinpath(dirname(@__DIR__), "Artifacts.toml")

rm(artifacts_toml)

plotschema_url = "https://api.plot.ly/v2/plot-schema?sha1"
plotschema_hash = create_artifact() do artifact_dir
    download(plotschema_url, joinpath(artifact_dir, "plotschema.json"))
end
bind_artifact!(artifacts_toml, "plotschema", plotschema_hash; download_info = [
    (plotschema_url, plotschema_hash)
])

plotly_url = "https://cdn.plot.ly/plotly-latest.min.js"
plotly_hash = create_artifact() do artifact_dir
    download(plotly_url, joinpath(artifact_dir, "plotly-latest.min.js"))
end
bind_artifact!(artifacts_toml, "plotly", plotly_hash; download_info = [
    (plotly_url, plotly_hash)
])
